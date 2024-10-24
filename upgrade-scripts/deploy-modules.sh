#!/bin/bash
#for i in `cat modules`
#curl --location --request POST 'https://okapi.medad.com/_/discovery/modules' --header 'x-okapi-token: eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJzdXBlcnVzZXIiLCJ1c2VyX2lkIjoiOTk5OTk5OTktOTk5OS00OTk5LTk5OTktOTk5OTk5OTk5OTk5IiwiaWF0IjoxNjIwMTE5ODI3LCJ0ZW5hbnQiOiJzdXBlcnRlbmFudCJ9.UVkDmJiB0TgqbwxOnkdk2-FlC_HEz7dKGI2p-bgPS0Y' --header 'Content-Type: application/json' --data-raw '{

 #       "instId": "mod-audit-2.2.2.1.0.1",

  #      "srvcId": "mod-audit-2.2.2.1.0.1",

   #     "url": "http://mod-audit:8081"

    #}'
for i in `cat backend-modules`; do x=`echo $i | rev | cut -d"-" -f2- | rev`; echo $x; curl --location --request POST "$dest_url/_/discovery/modules" --header "x-okapi-token: $okapitoken" --header 'Content-Type: application/json' --data-raw '{ "instId": "'"$i"'", "srvcId": "'"$i"'", "url": "http://'"$x"':8081"}'; done
