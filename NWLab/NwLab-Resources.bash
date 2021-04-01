#Create Variables
#Get Login Name as prefix
a=$(az ad signed-in-user show --query userPrincipalName)
A=$(echo "$a" | sed -e 's/\(.*\)/\L\1/')
B=${A:$(echo `expr index "$A" @`)}
C=${B:: -24}
D=$(echo "$C"rg01)
E=$(echo "$C"rg02)
#Provide Resource Values
RG1=NwLab-RG01
RG2=NwLab-RG02
VNet1=VNet01
VNet2=VNet02 
Nsg1=NSG1
Nsg2=NSG2
L=westeurope
VM1=VM-A
VM2=VM-R
VM3=VM-B
VM4=VM-X
#Set VM Configuration
OS=Win2019DataCenter
VMSize=standard_B2ms
Pip1=$(echo "$VM1"-Pip)
Pip2=$(echo "$VM2"-Pip)
Pip3=$(echo "$VM3"-Pip)
Pip4=$(echo "$VM4"-Pip)
#Set VNet Configuration
AP1="172.16.0.0/16"
AP2="10.0.0.0/8"
subnet11="172.16.1.0/24"
subnet12="172.16.2.0/24"
subnet21="10.1.1.0/24"
subnet22="10.2.2.0/24"
#Provide VM Credentials
user=QA
pass=1q2w3e4r5t6y*

#Create Resources

#Create RGs
az group create -n $RG1 -l $L
az group create -n $RG2 -l $L

#Create Storage Accounts
az storage account create -n $D -g $RG1 --kind Storage -l $L --sku Standard_LRS
az storage account create -n $E -g $RG2 --kind Storage -l $L --sku Standard_LRS

#Create NSGs
az network nsg create -g $RG1 -n $Nsg1
az network nsg rule create -g $RG1 --nsg-name $Nsg1 -n $Nsg1 --priority 100 --destination-port-ranges "*" --direction Inbound

az network nsg create -g $RG2 -n $Nsg2
az network nsg rule create -g $RG2 --nsg-name $Nsg2 -n $Nsg2 --priority 100 --destination-port-ranges "*" --direction Inbound

#Create VNets
az network vnet create --resource-group $RG1 --name $VNet1 --address-prefixes $AP1 --subnet-name VN01SN01 --subnet-prefix $subnet11
az network vnet subnet create --resource-group $RG1  --vnet-name $VNet1 --name VN01SN02 --address-prefix $subnet12

#Get VNet and Subnet Values
export SUBNETID1=$(az network vnet subnet show --resource-group $RG1 --vnet-name $VNet1 --name VN01SN01 --query id -o tsv)
export SUBNETN1=$(az network vnet subnet show --resource-group $RG1 --vnet-name $VNet1 --name VN01SN01 --query name -o tsv)


export SUBNETID2=$(az network vnet subnet show --resource-group $RG1 --vnet-name $VNet1 --name VN01SN02 --query id -o tsv)
export SUBNETN2=$(az network vnet subnet show --resource-group $RG1 --vnet-name $VNet1 --name VN01SN02 --query name -o tsv)


#Assign NSGs to VNets
az network vnet subnet update -g $RG1 --vnet-name $VNet1 -n $SUBNETN1 --network-security-group $Nsg1
az network vnet subnet update -g $RG1 --vnet-name $VNet1 -n $SUBNETN2 --network-security-group $Nsg1



#Create VMs on VNet01
az vm create --resource-group $RG1 -n $VM1 -l $L --image $OS --admin-username $user --admin-password $pass --size $VMSize --public-ip-address $Pip1 --public-ip-address-allocation static --subnet $SUBNETID1 --boot-diagnostics-storage $D --license-type Windows_Server --nsg "" --no-wait

az vm create --resource-group $RG1 -n $VM2 -l $L --image $OS --admin-username $user --admin-password $pass --size $VMSize --public-ip-address $Pip2 --public-ip-address-allocation static --subnet $SUBNETID2 --boot-diagnostics-storage $D --license-type Windows_Server --nsg "" --no-wait



#Create Second VNet

az network vnet create --resource-group $RG2 --name $VNet2  --address-prefixes $AP2 --subnet-name VN02SN01 --subnet-prefix $subnet21
az network vnet subnet create --resource-group $RG2  --vnet-name $VNet2 --name VN02SN02 --address-prefix $subnet22

#Get VNet and Subnet Values of Second VNet
export SUBNETID3=$(az network vnet subnet show --resource-group $RG2 --vnet-name $VNet2 --name VN02SN01 --query id -o tsv)
export SUBNETN3=$(az network vnet subnet show --resource-group $RG2 --vnet-name $VNet2 --name VN02SN01 --query name -o tsv)

export SUBNETID4=$(az network vnet subnet show --resource-group $RG2 --vnet-name $VNet2 --name VN02SN02 --query id -o tsv)
export SUBNETN4=$(az network vnet subnet show --resource-group $RG2 --vnet-name $VNet2 --name VN02SN02 --query name -o tsv)

#Assign NSGs
az network vnet subnet update -g $RG2 --vnet-name $VNet2 -n $SUBNETN3 --network-security-group $Nsg2
az network vnet subnet update -g $RG2 --vnet-name $VNet2 -n $SUBNETN4 --network-security-group $Nsg2


#Create VMs on VNet02

az vm create --resource-group $RG2 -n $VM3 -l $L --image $OS --admin-username $user --admin-password $pass --size $VMSize --public-ip-address $Pip3 --public-ip-address-allocation static --subnet $SUBNETID3 --boot-diagnostics-storage $E --license-type Windows_Server --nsg "" --no-wait
az vm create --resource-group $RG2 -n $VM4 -l $L --image $OS --admin-username $user --admin-password $pass --size $VMSize --public-ip-address $Pip4 --public-ip-address-allocation static --subnet $SUBNETID4 --boot-diagnostics-storage $E --license-type Windows_Server --nsg ""






