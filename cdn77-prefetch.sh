#!/bin/bash

FILE="/tmp/"$(date +"%Y-%m-%d-%Y-%H-%M")"-sitemap"

function cleanup
{
        rm -f $FILE*
}

if [ -z $1 ] ; then
	echo "please provide parameter <site>, e.g. www.mysite.com"
	exit 250
fi

if [ -z "$CDN77_TOKEN" ] ; then
	echo "please provide environment variable CDN_TOKEN, see https://client.cdn77.com/account/api"
	exit 251
fi

site_id=$(curl -s -X GET https://api.cdn77.com/v3/cdn --header "Authorization: Bearer $CDN77_TOKEN" | jq --arg site $1 '.[] | select(.cnames[] | .cname==$site) | .id')
if [ -z $site_id ] ; then
        echo "$1 is not on CDN77"
        exit 240
fi


status_code=$(curl --write-out %{http_code} --silent --output $FILE https://$1/sitemap.txt)

if [ "$status_code" -ne 200 ] ; then
	echo "error $status_code fetching sitemap.txt from $1"
	cleanup
	exit 230
fi

split -l 1999 $FILE $FILE.

let i=$(find /tmp -type f 2> /dev/null | grep $FILE. | wc -l)
if [ $i -ge 20 ]; then
	let t=15
else
	let t=1
fi

while read f; do
	curl -s -X POST https://api.cdn77.com/v3/cdn/$site_id/job/prefetch -H "Content-Type: application/json" --header "Authorization: Bearer $CDN77_TOKEN" -d "$(echo "{ \"paths\":  $(cat $f | sed -e "s,^https://$1,," | jq -R -s -c 'split("\n")[:-1]'), \"upstream_host\": \"$1\" }")" | jq
	echo "Sleeping "$t"s"
	sleep $t
done < <(find /tmp -type f 2> /dev/null | grep $FILE.)

cleanup
