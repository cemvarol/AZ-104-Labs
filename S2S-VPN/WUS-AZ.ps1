New-AzureRmResourceGroup -ResourceGroupName WUS-Assets -Location "West Us"

# Create the virtual network resources

$GWsubnet = New-AzureRmVirtualNetworkSubnetConfig `
  -Name "GatewaySubnet" `
  -AddressPrefix 10.202.0.128/25
$Subnet = New-AzureRmVirtualNetworkSubnetConfig `
  -Name "WUS-VNet01A-SN01" `
  -AddressPrefix 10.202.2.0/24


  $WUSVNet01A = New-AzureRmVirtualNetwork `
  -ResourceGroupName "WUS-Assets" `
  -Name "WUS-VNet01A" `
  -Location "West Us" `
  -AddressPrefix 10.202.0.0/16 `
  -Subnet $GWsubnet, $Subnet

  
  
$RG = "WUS-Assets"
$Location = "West Us"
$GWName = "WUSGW-A"
$GWIPName = "WUSGW-APiP"
$GWIPconfName = "WUSGW-Aipconf"
$VNetName = "WUS-VNet01A"


#Store the virtual network object as a variable.
$WUSVNet01A= Get-AzureRmVirtualNetwork -Name $VNetName -ResourceGroupName $RG

#Store the gateway subnet as a variable.
$GWsubnet = Get-AzureRmVirtualNetworkSubnetConfig -Name "GatewaySubnet" -VirtualNetwork $WUSVNet01A 

#Request a public IP address.
$pip = New-AzureRmPublicIpAddress -Name $GWIPName  -ResourceGroupName $RG -Location $Location -AllocationMethod Dynamic

#Create the configuration for your gateway
$ipconf = New-AzureRmVirtualNetworkGatewayIpConfig -Name $GWIPconfName -Subnet $GWsubnet -PublicIpAddress $pip

#Create the gateway
New-AzureRmVirtualNetworkGateway -Name $GWName -ResourceGroupName $RG -Location $Location -IpConfigurations $ipconf -GatewayType Vpn -VpnType RouteBased -GatewaySku Standard 




