#!/bin/bash

curl --location 'https://okapi.medadstg.com/_/proxy/tenants/medad/install' \
--header 'x-okapi-tenant: supertenant' \
--header 'x-okapi-token: eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJzdXBlcnVzZXIiLCJ0eXBlIjoibGVnYWN5LWFjY2VzcyIsInVzZXJfaWQiOiI5OTk5OTk5OS05OTk5LTQ5OTktOTk5OS05OTk5OTk5OTk5OTkiLCJpYXQiOjE2NjcyMjQ2MzUsInRlbmFudCI6InN1cGVydGVuYW50In0.gJAnqObQYE_fnVVkhQyVF-98eqHBmEGZ0lPITKtjc-Q' \
--header 'Cookie: PORTALSESSION=okapi-stg' | grep -B 3 "invoke"

