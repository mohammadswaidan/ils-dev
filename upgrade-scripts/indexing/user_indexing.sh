#!/bin/bash

# Function to get userid 
get_userid() {
    local host="$1"
    local okapi_token="$2"
    local username="$3"
    local user_url="${host}/users?query=username==\"$username\""
    local response=$(curl -s "$user_url" -H "accept: application/json" -H "content-type: application/json" -H "x-okapi-token: $okapi_token")
    local id=$(echo "$response" | jq -r '.users[0].id')
    echo $id
}

# Function to add permission for user
add_user_permissions() {
    local host="$1"
    echo $host
    local okapi_token="$2"
    echo $okapi_token
    local user_id="$3"
    echo $user_id
    local perms_url="${host}/perms/users/${user_id}/permissions?indexField=userId"
    local response=$(curl -s -X POST "$perms_url" -H "accept: application/json" -H "content-type: application/json" -H "x-okapi-token: $okapi_token" -d '{"permissionName":"ui-users.reIndex.create.index"}')
    echo "$response"
}

# Function to perform the login and return the okapiToken
perform_login() {
    local host="$1"
    local x_okapi_tenant="$2"
    local username="$3"
    local password="$4"
    local login_url="${host}/authn/login"
    local response=$(curl -s -X POST "$login_url" -H "X-Okapi-Tenant: $x_okapi_tenant" -H 'Content-Type: application/json' -d "{\"username\":\"$username\",\"password\":\"$password\"}")
    local okapi_token=$(echo "$response" | jq -r '.okapiToken')
    echo "$okapi_token"
}

# Function to perform the second request with the obtained okapiToken
perform_second_request() {
    local host="$1"
    local okapi_token="$2"
    local search_url="${host}/search/index/user/reindex"
    local response=$(curl -s -X POST "$search_url" -H "accept: application/json" -H "content-type: application/json" -H "x-okapi-token: $okapi_token" -d '{"recreateIndex":true,"resourceName":"user"}')
    echo "$response"
}

# Main loop to read tenant info and perform requests
csv_filename="tenants.csv"  # Update with your CSV filename
host_variable="https://okapi.medadqa.com"  # Update with your host variable

IFS=$'\n'  # Set Internal Field Separator to newline to handle CSV lines
for line in $(tail -n +1 "$csv_filename"); do
    tenant_id=$(echo "$line" | cut -d ',' -f 1)
    echo $tenant_id
    x_okapi_tenant="$tenant_id"
    username=$(echo "$line" | cut -d ',' -f 2)
    echo $username
    password="$(echo "$line" | cut -d ',' -f 3)"
    echo $password
    login_token=$(perform_login "$host_variable" "$x_okapi_tenant" "$username" "$password")
    echo $login_token
    userid=$(get_userid "$host_variable" "$login_token" "$username")
    echo $userid
    addperms=$(add_user_permissions "$host_variable" "$login_token" "$userid")
    echo "perms resp: $addperms"
    sleep 30
    while true; do
      if [ -n "$login_token" ]; then
        second_response=$(perform_second_request "$host_variable" "$login_token")
        if [ $? -eq 0 ]; then
            echo "Tenant ID: $tenant_id"
            echo "Second request response: $second_response"
            break  # Success, so exit the loop
        else
            echo "Request failed. Retrying in $retry_interval seconds..."
            sleep $retry_interval
        fi
      else
        echo "Login failed for Tenant ID: $tenant_id"
        break  # No need to retry if login failed
      fi
    done

done

