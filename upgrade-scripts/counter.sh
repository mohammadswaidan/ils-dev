#/bin/bash

tenants_no=0

for l in `cat tenants`; do
((tenants_no++));
done
echo $tenants_no

