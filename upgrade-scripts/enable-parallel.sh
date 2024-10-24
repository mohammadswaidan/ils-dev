#!/bin/bash
#for i in `cat modules`
#curl --location --request POST 'https://okapi-qa.medadstg.com/_/discovery/modules' --header 'x-okapi-token: eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJzdXBlcnVzZXIiLCJ0eXBlIjoibGVnYWN5LWFjY2VzcyIsInVzZXJfaWQiOiI5OTk5OTk5OS05OTk5LTQ5OTktOTk5OS05OTk5OTk5OTk5OTkiLCJpYXQiOjE2NzgwMjQ0MjksInRlbmFudCI6InN1cGVydGVuYW50In0.WGKuOXBiKDuMVr1INGIR697UrUbr4NB8gyQazJKy8eE' --header 'Content-Type: application/json' --data-raw '{

 #       "instId": "mod-audit-2.2.2.1.0.1",

  #      "srvcId": "mod-audit-2.2.2.1.0.1",

   #     "url": "http://mod-audit:8081"

    #}'
#for i in `cat modules`; do curl --location --request POST 'https://okapi-qa.medadstg.com/_/discovery/modules' --header 'x-okapi-token: eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJzdXBlcnVzZXIiLCJ0eXBlIjoibGVnYWN5LWFjY2VzcyIsInVzZXJfaWQiOiI5OTk5OTk5OS05OTk5LTQ5OTktOTk5OS05OTk5OTk5OTk5OTkiLCJpYXQiOjE2NzgwMjQ0MjksInRlbmFudCI6InN1cGVydGVuYW50In0.WGKuOXBiKDuMVr1INGIR697UrUbr4NB8gyQazJKy8eE' --header 'Content-Type: application/json' --data-raw '{ "instId": "$i", "srvcId": "$i", "url": "$x:8081"}'; done


###### generate module json
source env.sh
rm -rf modules-enable.json
echo "[" > modules-enable.json
for i in `cat backend-modules`; do data=" {\"id\": \"$i\", \"action\": \"enable\"}," ; echo $data >> modules-enable.json; done 
for i in `cat frontend-modules`; do data=" {\"id\": \"$i\", \"action\": \"enable\"}," ; echo $data >> modules-enable.json; done 
sed '$ s/,$//g' -i  modules-enable.json
echo "]" >> modules-enable.json


### get tenants 

curl -s --location --request GET "$dest_url/_/proxy/tenants" --header "x-okapi-token: $okapitoken" --header 'Cookie: PORTALSESSION=okapi-stg' > tenants
grep -nr '"id"' tenants  | cut -d : -f3 | cut -d , -f1 | cut -d '"' -f2 > tmpfile && mv tmpfile tenants
sed '/supertenant/d' tenants > tmpfile && mv tmpfile tenants
tenant_num=$(cat tenants | wc -l)
echo "Total number of tenants:$tenant_num"
tenant_enabled=0
###### enable backend modules 

echo "Enabling Backend Modules"
for j in `cat tenants` ; do

start_time=$(date +%s)


echo  -e "\nTenant:$tenant_enabled - $j"; 
tenant_enabled=$((tenant_enabled + 1))


curl -s --location --request DELETE "$dest_url/_/proxy/tenants/$j/install" --header "x-okapi-token: $okapitoken" --header 'Content-Type: application/json'



curl -s --location --request POST "$dest_url/_/proxy/tenants/$j/install?deploy=false&tenantParameters=loadSample%3Dfalse%2CloadReference%3Dtrue" --header "x-okapi-token: $okapitoken" --header 'Content-Type: application/json' --data-binary @modules-enable.json --max-time 1;

sleep 250

done 

####### check tenant status before enable next tenant #################




#!/bin/bash


tenants_no=0

for l in `cat tenants`; do
((tenants_no++));
done


echo $tenants_no


sleep 2

counter=0
completed_tenants=()



while [ "$counter" -lt "$tenants_no" ]; do



for x in `cat tenants` ; do
    output=$(curl -s --location --request GET "$dest_url/_/proxy/tenants/$x/install" --header "x-okapi-token: $okapitoken" --header 'Content-Type: application/json')


    #sleep 2
    if echo "$output" | grep -q -e "invoke" -e "pending"; then
        echo "Tenant $x : Pending"
    else
       # end_time=$(date +%s)
# execution_time=$((end_time - start_time))
       # execution_time_minutes=$((execution_time / 60))
       #        echo $execution_time_minutes
      #echo "Installation completed successfully For Tenant $j in $execution_time_minutes minutes!"
echo "Tenant $x Done"


      if [[ ! " ${completed_tenants[@]} " =~ " $x " ]]; then
      echo "$x is not in the array list"
      completed_tenants+=($x)
      ((counter++))
      echo $counter
      else
      echo "$x is present in the array list"
      fi

      #break
   fi



done

      echo ${completed_tenants[@]}
      echo $counter
done

