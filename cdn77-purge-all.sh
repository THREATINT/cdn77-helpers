#!/bin/bash
if [ -z $1 ] ; then
	echo "please provide parameter <site>, e.g. www.mysite.com"
	exit 250
fi

if [ -z "$CDN77_TOKEN" ] ; then
        echo "please provide environment variable CDN77_TOKEN, see https://client.cdn77.com/account/api"
        exit 251
fi

h=$(curl -o /dev/null -w "%{http_code}" -s --request GET https://api.cdn77.com/v3/cdn --header "Authorization: Bearer $CDN77_TOKEN")
if [ $h != 200 ]; then
	curl -s --request GET https://api.cdn77.com/v3/cdn --header "Authorization: Bearer $CDN77_TOKEN"
	exit 255
fi

site_id=$(curl -s --request GET https://api.cdn77.com/v3/cdn --header "Authorization: Bearer $CDN77_TOKEN" | jq --arg site $1 '.[] | select(.cnames[] | .cname==$site) | .id')
if [ -z $site_id ]; then
        echo "$1 is not on CDN77"
        exit 240
fi

curl -s --request POST https://api.cdn77.com/v3/cdn/$site_id/job/purge-all --header "Authorization: Bearer $CDN77_TOKEN" | jq
