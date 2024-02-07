@description('Specifies the location for the deployment.')
param prefix string //= 'fsk5'

@description('Specifies the name of the resource group for the VWan.')
param privateCloudRGName string = '${prefix}-avs-${avsRGLocation}'

@description('Specifies the location of the resource group for the VWan.')
param avsRGLocation string = 'swedencentral'

@description('Specifies the name of the resource group for the VWan.')
param vwanRGName string = '${prefix}-vwan-${vwanRGLocation}'

@description('Specifies the location of the resource group for the VWan.')
param vwanRGLocation string = 'swedencentral'

@description('Specifies the tags top be added to the resources.')
param resourceTags object = {
  Environment: 'PoC'
  Project: 'vWan Tutorial'
  Technology: 'AVS'
  Deployment: 'Bicep'
  'Can Be Deleted': 'Yes'
}

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

@description('Specifies the location of the resource group for the VWan.')
param vhubRGLocation string = 'swedencentral'

@description('Specifies the Virtual Hub Address Prefix.')
param vwanHubAddressPrefix string = '10.10.10.0/24'

@description('Specifies whether or not to deploy s2s connection.')
param deployS2SConnection bool = true

@description('Specifies whether or not to deploy ExR connection.')
param deployExRConnection bool = true

@description('Specifices the IP Address of the VPN gateway device')
param vpnDeviceIP string // = '1.2.3.4'

@description('Specifices the VPN Sites local IP Addresses')
param vpnRangeCIDR string = '192.168.1.0/24'

//@description('Specifies the name of the vwan instance.')
//param vwanName string = 'wan1-${vwanRGLocation}'

@description('Specifies the name of the vwan instance.')
var vwanName = 'wan1-${vwanRGLocation}'

@description('Specifies the name of the vwan hub.')
var vwanHubName = 'hub1-${vwanRGLocation}'

@description('Specifies the name of the vpn gateway.')
var vwanHubGatewayName = 'hub1-${vwanRGLocation}-vpngw1'

@description('Specifies the name of the vpn gateway.')
var vwanHubVpnSiteName = 'hub1-${vwanRGLocation}-vpnsite1'

@description('Specifies the name of the virtual hub instance.')
var hubExpressRouteGatewayName = 'hub1-${vwanRGLocation}-exrgw1'

// Scope
targetScope = 'subscription'

resource privateCloudRG 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: privateCloudRGName
  location: avsRGLocation
  tags: resourceTags
}

resource vwanRG 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: vwanRGName
  location: vwanRGLocation
  tags: resourceTags
}

module virtualWan 'modules/vwan/vwan.bicep' = {
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
  dependsOn: [
    privateCloudRG
  ]
}

module vwanHub 'modules/vwan/vwanhub.bicep' = {
  name: 'deploy-${vwanHubName}'
  scope: vwanRG
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

module vwanHubVpnGateway 'modules/vwan/vwanhubvpngw.bicep' = if (deployS2SConnection) {
  name: 'deploy-${vwanHubGatewayName}'
  scope: vwanRG
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

module vwanHubVpnSite 'modules/vwan/vwanhubvpnsite.bicep' = if (deployS2SConnection) {
  name: 'deploy-${vwanHubVpnSiteName}'
  scope: vwanRG
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

module vwanHubExRGateway 'modules/vwan/vwanhubexrgw.bicep' = if (deployExRConnection) {
  name: 'deploy-${hubExpressRouteGatewayName}'
  scope: vwanRG
  params: {
    resourceTags: resourceTags
    virtualHubID: vwanHub.outputs.hubID
    hubExpressRouteGatewayName: hubExpressRouteGatewayName
    vwanHubLocation: vhubRGLocation
  }
}
