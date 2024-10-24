#!/bin/bash

# Set the destination URL and Okapi token
#dest_url="https://example.com"
#okapitoken="YOUR_OKAPI_TOKEN"

# Set the maximum number of retries
max_retries=5

# Initialize the counter
counter=0

# Perform the curl command and check the output
while true; do
    output=$(curl  --location --request GET "$dest_url/_/proxy/tenants/medad/install" --header "x-okapi-token: $okapitoken" --header 'Content-Type: application/json')

    if echo "$output" | grep -q -e "invoke" -e "pending"; then
        echo "Installation not completed yet. Retrying..."
        sleep 10
    else
      echo "Installation completed successfully!"
      break
   fi



done

