a=$(az ad signed-in-user show --query userPrincipalName)
A=$(echo "$a" | sed -e 's/\(.*\)/\L\1/')
B=${A:$(echo `expr index "$A" @`)}
C=${B:: -24}
D=$(echo "$C"id01)
L=westeurope


az group create --name IDLab1 --location $L
az group create --name IDLab2 --location $L

az storage account create --name $D --resource-group IDLab1 --kind Storage --location $L --sku Standard_LRS

az network nsg create -g IDLab1 -n IDsNSG
az network nsg rule create -g IDLab1 --nsg-name IDsNSG -n ConRule --priority 100 --destination-port-ranges "*" --direction Inbound


az network vnet create --resource-group IDLab1 --name IDVnet01  --address-prefixes 10.206.0.0/16 --subnet-name SN01 --subnet-prefix 10.206.1.0/24

export SUBNETID=$(az network vnet subnet show --resource-group IDLab1 --vnet-name IDVnet01 --name SN01 --query id -o tsv)
export SUBNETN=$(az network vnet subnet show --resource-group IDLab1 --vnet-name IDVnet01 --name SN01 --query name -o tsv)

az network vnet subnet update -g IDLab1 --vnet-name IDVnet01 --name $SUBNETN --network-security-group IDsNSG

az vm create --resource-group IDLab1 --name IDs-VM01 --location $L --image MicrosoftWindowsServer:WindowsServer:2019-Datacenter-Core:latest --admin-username cem --admin-password 1q2w3e4r5t6y* --size standard_D4s_v3 --public-ip-address "IDs-VM01-Pip" --subnet $SUBNETID --boot-diagnostics-storage $D --license-type Windows_Server --nsg "" --no-wait
