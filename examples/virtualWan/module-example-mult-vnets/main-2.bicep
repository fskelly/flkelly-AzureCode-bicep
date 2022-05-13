//@description('Specifies the location for the deployment.')
//param location string = 'northeurope'

@description('Specifies the location for the deployment.')
param prefix string //= 'fsk5'

@description('Specifies the name of the resource group for the VWan.')
param vwanRGName string = '${prefix}-vwan-${vwanRGLocation}'

@description('Specifies the location of the resource group for the VWan.')
param vwanRGLocation string = 'northeurope'

//@description('Specifies the name of the resource group for the VWan.')
//param vhubRGName string = '${prefix}-vhub-${vwanRGLocation}'

@description('Specifies the location of the resource group for the VWan.')
param vhubRGLocation string = 'northeurope'

@description('Specifies the name of the vwan instance.')
param vwanName string = 'wan1-${vwanRGLocation}'

@description('Specifies the name of the vwan hub.')
param vwanHubName string = 'hub1-${vwanRGLocation}'

@description('Specifies the Virtual Hub Address Prefix.')
param vwanHubAddressPrefix string = '10.10.10.0/24'

@description('Specifies the name of the vpn gateway.')
param vwanHubGatewayName string = 'hub1-${vwanRGLocation}-vpngw1'

@description('Specifies the name of the vpn gateway.')
param vwanHubVpnSiteName string = 'hub1-${vwanRGLocation}-vpnsite1'

@description('Specifies the name of the virtual hub instance.')
param hubExpressRouteGatewayName string = 'hub1-${vwanRGLocation}-exrgw1'

@secure()
@description('Pre-Shared Key used to establish the site to site tunnel between the Virtual Hub and On-Prem VNet')
param psk string

@description('Specifices the IP Address of the VPN gateway device')
param vpnDeviceIP string // = '1.2.3.4'

//@description('Specifices the VPN Sites VPN Device FQDN')
//param fqdn string = 'device.fqdn'

@description('Specifices the VPN Sites local IP Addresses')
param vpnRangeCIDR string = '192.168.1.0/24'

@description('Specifices the VNET1 Address Prefix')
param vnetCIDR string = '172.16.10.0/24'

@description('Specifies the name of the subnet.')
param snetName string = 'snet1'

@description('Specifices the Subnet1 Address Prefix')
param snetCIDR string = '172.16.10.0/26'

@description('Specifices the VNET1 name')
param vnetName string = 'vnet1'

@description('Specifies whether or not to deploy vnet connection.')
param deployVnetConnection bool = true

@description('Specifies whether or not to deploy s2s connection.')
param deployS2SConnection bool = true

@description('Specifies whether or not to deploy ExR connection.')
param deployExRConnection bool = true

//@description('BGP AS-number for the VPN Gateway')
//param asn int

@allowed([
  'Standard'
  'Basic'
])
@description('vwan hub SKU')
param vwantype string = 'Standard'

@description('Enable / disable VpnEncryption')
param disableVpnEncryption bool = false

@description('Enable / disable branch to branch traffic')
param allowBranchToBranchTraffic bool = true

@description('Enable / disable vnet to vnet traffic')
param allowVnetToVnetTraffic bool = true

@description('Specifies the tags top be added to the resources.')
param resourceTags object = {
  Environment: 'PoC'
  Project: 'vWan Tutorial'
  Technology: 'AVS'
  Deployment: 'Bicep'
  'Can Be Deleted': 'Yes'
}

// Scope
targetScope = 'subscription'

resource vwanRG 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: vwanRGName
  location: vwanRGLocation
  tags: resourceTags
}

module virtualNetwork 'modules/vnets-2.bicep' = if (deployVnetConnection == true) {
  //name: 'deploy-vnetconnection'{
  name: 'deploy-${vnetName}'
  scope: vwanRG
  params: {
    //tags: resourceTags
    //vnetName: vnetName
    vnetCount: 2
  }
}

