//@description('Specifies the location for the deployment.')
//param location string = 'northeurope'

@description('Specifies the location for the deployment.')
param prefix string //= 'fsk5'

@description('Specifies the name of the resource group for the VWan.')
param vwanRGName string = '${prefix}-vwan-${vwanRGLocation}'

@description('Specifies the location of the resource group for the VWan.')
param vwanRGLocation string = 'northeurope'

@description('Specifies the name of the resource group for the VWan.')
param vhubRGName string = '${prefix}-vhub-${vwanRGLocation}'

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
param deployVnetConnection bool //= false

@description('Specifies whether or not to deploy s2s connection.')
param deployS2SConnection bool //= false

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

resource vhubRG 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: vhubRGName
  location: vhubRGLocation
  tags: resourceTags
}

module virtualWan 'modules/vwan.bicep' = {
  name: 'deploy-${vwanName}'
  scope: vwanRG
  params: {
    vwantype: vwantype
    disableVpnEncryption: disableVpnEncryption
    allowBranchToBranchTraffic: allowBranchToBranchTraffic
    allowVnetToVnetTraffic: allowVnetToVnetTraffic
    vwanLocation: vwanRGLocation
    vwanName: vwanName
    resourceTags: resourceTags
  }
}

module vwanHub 'modules/vwanhub.bicep' = {
  name: 'deploy-${vwanHubName}'
  scope: vhubRG
  params: {
    vwanHubAddressPrefix: vwanHubAddressPrefix
    hubName: vwanHubName
    vwanID: virtualWan.outputs.vWanID
    vwanHubLocation: vhubRGLocation
    resourceTags: resourceTags
    //vnetID: virtualNetwork.outputs.vnetID
    //vnetName: vnetName
  }
}

module vwanHubVpnGateway 'modules/vwanhubvpngw.bicep' = if (deployS2SConnection) {
  name: 'deploy-${vwanHubGatewayName}'
  scope: vhubRG
  params: {
    resourceTags: resourceTags
    vwanHubGatewayName: vwanHubGatewayName
    vwanHubID: vwanHub.outputs.hubID
    vwanHubLocation: vhubRGLocation
    //psk: psk
    //remoteVpnSiteID: vwanHubVpnSite.outputs.vwanHubVpnSiteID
  }
  //dependsOn: [
  //  vwanHubExRGateway
  //]
}

module vwanHubVpnSite 'modules/vwanhubvpnsite.bicep' = if (deployS2SConnection) {
  name: 'deploy-${vwanHubVpnSiteName}'
  scope: vhubRG
  params: {
    resourceTags: resourceTags
    vwanHubID: virtualWan.outputs.vWanID
    vwanHubVpnSiteName: vwanHubVpnSiteName
    vwanHubLocation: vhubRGLocation
    vpnDeviceIP: vpnDeviceIP
    vpnRangeCIDR: vpnRangeCIDR
  }
  //dependsOn: [
  //  vwanHubExRGateway
  //]
}

module vwanHubExRGateway 'modules/vwanhubexrgw.bicep' = if (deployExRConnection) {
  name: 'deploy-${hubExpressRouteGatewayName}'
  scope: vhubRG
  params: {
    resourceTags: resourceTags
    virtualHubID: vwanHub.outputs.hubID
    hubExpressRouteGatewayName: hubExpressRouteGatewayName
    vwanHubLocation: vhubRGLocation
  }
}

module virtualNetwork 'modules/vnet.bicep' = if (deployVnetConnection) {
  //name: 'deploy-vnetconnection'{
  name: 'deploy-${vnetName}'
  scope: vhubRG
  params: {
    resourceTags: resourceTags
    snetCIDR: snetCIDR
    snetName: snetName
    vnetCIDR: vnetCIDR
    vnetLocation: vhubRGLocation
    vnetName: vnetName
  }
}

module vnetConnection 'modules/vnetconnection.bicep' = if (deployVnetConnection) {
  scope: vhubRG
  name: 'deploy-vnetconnection'
  params: {
    //hubName: vwanHubName
    virtualWanHubName: vwanHubName
    vnetID: virtualNetwork.outputs.vnetID
    vnetName: vnetName
  }
  dependsOn: [
    vwanHubVpnGateway
  ]
}

module vpnConnection 'modules/vwanhubvpnconnection.bicep' = if (deployS2SConnection) {
  scope: vhubRG
  name: 'deploy-vpnconnection'
  params: {
    psk: psk
    remoteVpnSiteID: vwanHubVpnSite.outputs.vwanHubVpnSiteID
    vwanHubGatewayName: vwanHubGatewayName
  }
  dependsOn: [
    vwanHubVpnGateway
  ]
}

output vwanRG string = vwanRG.name
output vhubRG string = vhubRG.name
