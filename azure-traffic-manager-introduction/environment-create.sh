group=azure-traffic-manager-introduction
az group create -g $group -l eastasia
username=adminuser
password='SecretPassword123!@#'
az vm create \
  -n vm-eastasia \
  -g $group \
  -l eastasia \
  --image Win2019Datacenter \
  --admin-username $username \
  --admin-password $password \
  --nsg-rule rdp
  
az vm create \
  -n vm-eastus2 \
  -g $group \
  -l eastus2 \
  --image Win2019Datacenter \
  --admin-username $username \
  --admin-password $password \
  --nsg-rule rdp

az appservice plan create \
  -n web-eastus2-plan \
  -g $group \
  -l eastus2 \
  --sku S1
  
appname=demo-web-eastus2-$RANDOM$RANDOM
az webapp create \
  -n $appname \
  -g $group \
  -p web-eastus2-plan
  
az appservice plan create \
  -n web-eastasia-plan \
  -g $group \
  -l eastasia \
  --sku S1
  
appname=demo-web-eastasia-$RANDOM$RANDOM
az webapp create \
  -n $appname \
  -g $group \
  -p web-eastasia-plan
  
az webapp list -g $group --query "[].enabledHostNames" -o jsonc

az vm list \
  -g $group -d \
  --query "[].{name:name,ip:publicIps,user:osProfile.adminUsername,password:'$password'}" \
  -o jsonc
