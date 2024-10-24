#!/bin/bash
#for i in `cat modules`
#curl --location --request POST 'https://okapi-qa.medadstg.com/_/discovery/modules' --header 'x-okapi-token: eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJzdXBlcnVzZXIiLCJ0eXBlIjoibGVnYWN5LWFjY2VzcyIsInVzZXJfaWQiOiI5OTk5OTk5OS05OTk5LTQ5OTktOTk5OS05OTk5OTk5OTk5OTkiLCJpYXQiOjE2NzgwMjQ0MjksInRlbmFudCI6InN1cGVydGVuYW50In0.WGKuOXBiKDuMVr1INGIR697UrUbr4NB8gyQazJKy8eE' --header 'Content-Type: application/json' --data-raw '{

 #       "instId": "mod-audit-2.2.2.1.0.1",

  #      "srvcId": "mod-audit-2.2.2.1.0.1",

   #     "url": "http://mod-audit:8081"

    #}'
#for i in `cat modules`; do curl --location --request POST 'https://okapi-qa.medadstg.com/_/discovery/modules' --header 'x-okapi-token: eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJzdXBlcnVzZXIiLCJ0eXBlIjoibGVnYWN5LWFjY2VzcyIsInVzZXJfaWQiOiI5OTk5OTk5OS05OTk5LTQ5OTktOTk5OS05OTk5OTk5OTk5OTkiLCJpYXQiOjE2NzgwMjQ0MjksInRlbmFudCI6InN1cGVydGVuYW50In0.WGKuOXBiKDuMVr1INGIR697UrUbr4NB8gyQazJKy8eE' --header 'Content-Type: application/json' --data-raw '{ "instId": "$i", "srvcId": "$i", "url": "$x:8081"}'; done


###### generate module json

rm -rf modules-enable.json
echo "[" > modules-enable.json
for i in `cat backend-modules`; do data=" {\"id\": \"$i\", \"action\": \"enable\"}," ; echo $data >> modules-enable.json; done 
for i in `cat frontend-modules`; do data=" {\"id\": \"$i\", \"action\": \"enable\"}," ; echo $data >> modules-enable.json; done 
sed '$ s/,$//g' -i  modules-enable.json
echo "]" >> modules-enable.json


### get tenants 

#curl -s --location --request GET "$dest_url/_/proxy/tenants" --header "x-okapi-token: $okapitoken" --header 'Cookie: PORTALSESSION=okapi-stg' > tenants
#grep -nr '"id"' tenants  | cut -d : -f3 | cut -d , -f1 | cut -d '"' -f2 > tmpfile && mv tmpfile tenants
#sed '/supertenant/d' tenants > tmpfile && mv tmpfile tenants
#tenant_num=$(cat tenants | wc -l)
#echo "Total number of tenants:$tenant_num"
tenant_enabled=0
###### enable backend modules 

echo "Enabling Backend Modules"
for j in `cat tenants` ; do
echo  -e "\nTenant:$tenant_enabled - $j"; 
tenant_enabled=$((tenant_enabled + 1))
curl -s --location --request DELETE "$dest_url/_/proxy/tenants/$j/install" --header "x-okapi-token: $okapitoken" --header 'Content-Type: application/json'


curl  -s --location --request POST "$dest_url/_/proxy/tenants/$j/install?deploy=false&tenantParameters=loadSample%3Dfalse%2CloadReference%3Dtrue" --header "x-okapi-token: $okapitoken" --header 'Content-Type: application/json'  --data-binary @modules-enable.json ; 

####### check tenant status before enable next tenant #################


while true; do
    output=$(curl -s --location --request GET "$dest_url/_/proxy/tenants/$j/install" --header "x-okapi-token: $okapitoken" --header 'Content-Type: application/json')

    if echo "$output" | grep -q -e "invoke" -e "pending"; then
        echo "Installation not completed yet For Tenant $j. Retrying..."
        sleep 10
    else
      echo "Installation completed successfully For Tenant $j !"
      break
   fi



done



done

echo "$tenant_enabled of $tenant_num Tenants enabled";

