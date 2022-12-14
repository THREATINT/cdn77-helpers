# cdn77-helpers
[CDN77](https://www.cdn77.com/) is a CDN (Content Delivery Network) service by DataCamp Limited, a UK based company. 

As a CDN77 customer, you can make use of their [REST API](https://client.cdn77.com/support/api-reference/v3/introduction) to automate CDN Resource management.

We use the scripts provided here on a daily basis when dealing with content delivery using CDN77 and hope you find them useful as well.

## Prerequisites
### Linux/Unix packages
You need [Bash](https://www.gnu.org/software/bash/), [curl](https://curl.se/), and [jq](https://stedolan.github.io/jq/), please run 

`sudo apt install bash curl jq` 

to install on Debian or Ubuntu.

### API Token
In order to use the REST API you need to generate an [API token](https://client.cdn77.com/account/api). Run 

`export cdn77_token=<token>` 

in Bash to make the token available to the scripts.


## Overview
We currently provide two scripts 
- `cdn77-purge-all` allows you to instantly remove all cached content from the CDN for a given site. 

- `cdn77-prefetch-all` populates the CDN cache for a given site using the information from its sitemap.txt, so that content is already available on all machines in all datacenters when clients start sending requests to the CDN. 


## Running
```cdn77-purge-all.sh <site>```

```cdn77-prefetch-all.sh <site>```

`<site>` is the site that is on CDN77, e.g. www.mysite.com.

## Feedback
We would love to hear from you! 

## Mailing list
Subscribe to our newsletter to learn more about our work.
[](https://newsletter.threatint.com/subscription?f=NiRp2763y19cplj796wGLZKeWSkrkkO8stBCsNbHL668BFHW478DRGNlNBXJZtV3rzH1DzWbtP8jGAJ4WDHmRPkw)

## License
Released under the [MIT License](https://opensource.org/licenses/MIT).