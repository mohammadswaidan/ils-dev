#!/bin/bash
curl -s --location --request GET "$source_url/_/proxy/tenants/medad/modules" \
--header "x-okapi-token: $okapitoken" \
--header 'Cookie: PORTALSESSION=okapi-stg' | cut -d : -f2 | tr -d '"' | grep - | grep mod > backend-modules


curl -s --location --request GET "$source_url/_/proxy/tenants/medad/modules" \
--header "x-okapi-token: $okapitoken" \
--header 'Cookie: PORTALSESSION=okapi-stg' | cut -d : -f2 | tr -d '"' | grep - | grep -v mod | grep -v okapi > frontend-modules
sed -i 's/ //g' backend-modules
sed -i 's/ //g' frontend-modules
