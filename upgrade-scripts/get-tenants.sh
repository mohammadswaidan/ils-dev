#!/bin/bash
curl -s --location --request GET "$dest_url/_/proxy/tenants" --header "x-okapi-token: $okapitoken" --header 'Cookie: PORTALSESSION=okapi-stg' > tenants
