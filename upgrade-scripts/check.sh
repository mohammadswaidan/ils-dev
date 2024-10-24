#!/bin/bash
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
#echo "Tenant $x Done"


      if [[ ! " ${completed_tenants[@]} " =~ " $x " ]]; then
      #echo "$x is not in the array list"
      completed_tenants+=($x)
      ((counter++))
      #echo $counter 
      #else
      #echo "$x is present in the array list"
      fi

      #break
   fi

   done

      echo ${completed_tenants[@]}
      echo $counter
done

