#!/bin/bash
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

status_code=$(curl --write-out %{http_code} --silent --output /dev/null https://$1/sitemap.txt)

if [ "$status_code" -ne 200 ] ; then
	echo "error $status_code fetching sitemap.txt from $1"
	exit 230
fi

curl -s -X POST https://api.cdn77.com/v3/cdn/$site_id/job/prefetch -H "Content-Type: application/json" --header "Authorization: Bearer $CDN77_TOKEN" -d "$(echo "{ \"paths\":  $(curl -s -X GET https://$1/sitemap.txt | sed -e "s,^https://$1,," | jq -R -s -c 'split("\n")[:-1]'), \"upstream_host\": \"$1\" }")" | jq
