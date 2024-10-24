#!/bin/bash

for i in `cat frontend-modules`; do echo $i; curl --location --request POST "$dest_url/_/proxy/modules" --header "x-okapi-token: $okapitoken" --header 'Cookie: PORTALSESSION=okapi-stg' --header 'Content-Type: application/json' --data-raw "`curl -s --location --request GET "$source_url/_/proxy/modules/${i}" --header "x-okapi-token: $okapitoken" --header 'Cookie: PORTALSESSION=okapi-stg'`"; done


for i in `cat backend-modules`; do echo $i; curl --location --request POST "$dest_url/_/proxy/modules" --header "x-okapi-token: $okapitoken" --header 'Cookie: PORTALSESSION=okapi-stg' --header 'Content-Type: application/json' --data-raw "`curl -s --location --request GET "$source_url/_/proxy/modules/${i}" --header "x-okapi-token: $okapitoken" --header 'Cookie: PORTALSESSION=okapi-stg'`"; done

