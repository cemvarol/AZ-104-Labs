New-AzureRmResourceGroup -ResourceGroupName SEA-Assets -Location "Southeast Asia"

# Create the virtual network resources

$GWsubnet = New-AzureRmVirtualNetworkSubnetConfig `
  -Name "GatewaySubnet" `
  -AddressPrefix 10.101.0.128/25
$Subnet = New-AzureRmVirtualNetworkSubnetConfig `
  -Name "SEA-VNet01A-SN01" `
  -AddressPrefix 10.101.1.0/24


  $SEAVNet01A = New-AzureRmVirtualNetwork `
  -ResourceGroupName "SEA-Assets" `
  -Name "SEA-VNet01A" `
  -Location "Southeast Asia" `
  -AddressPrefix 10.101.0.0/16 `
  -Subnet $GWsubnet, $Subnet

  
  
$RG = "SEA-Assets"
$Location = "Southeast Asia"
$GWName = "SEAGW-A"
$GWIPName = "SEAGW-APiP"
$GWIPconfName = "SEAGW-Aipconf"
$VNetName = "SEA-VNet01A"


#Store the virtual network object as a variable.
$SEAVNet01A= Get-AzureRmVirtualNetwork -Name $VNetName -ResourceGroupName $RG

#Store the gateway subnet as a variable.
$GWsubnet = Get-AzureRmVirtualNetworkSubnetConfig -Name "GatewaySubnet" -VirtualNetwork $SEAVNet01A 

#Request a public IP address.
$pip = New-AzureRmPublicIpAddress -Name $GWIPName  -ResourceGroupName $RG -Location $Location -AllocationMethod Dynamic

#Create the configuration for your gateway
$ipconf = New-AzureRmVirtualNetworkGatewayIpConfig -Name $GWIPconfName -Subnet $GWsubnet -PublicIpAddress $pip

#Create the gateway
New-AzureRmVirtualNetworkGateway -Name $GWName -ResourceGroupName $RG -Location $Location -IpConfigurations $ipconf -GatewayType Vpn -VpnType RouteBased -GatewaySku Standard 





