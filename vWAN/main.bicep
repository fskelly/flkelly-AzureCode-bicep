targetScope = 'subscription'

@description('Specify the location for the hub Virtual Network and its related resources')
param hubLocation string = 'northeurope'

@description('Specify the location for the vWAN and its related resources')
param vwanLocation string = 'northeurope'

@description('Specify the name prefix for all resources and resource groups')
param nameprefix string = 'flkelly'

var vwanname = '${nameprefix}-vwan'
var vhubname = '${nameprefix}-vhub-${vwanLocation}'

resource hubrg 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: '${nameprefix}-vnetHub01-rg'
  location: hubLocation
}

resource vwanrg 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: '${nameprefix}-vwan01-rg'
  location: vwanLocation
}

module vwan 'modules/vwan.bicep' = {
  name: 'vwan-deploy'
  scope: vwanrg
  params: {
    location: vwanLocation
    wanname: vwanname
    wantype: 'Standard'
  }
}

module vhub 'modules/vhub.bicep' = {
  name: 'vhub-deploy'
  scope: vwanrg
  params: {
    location: vwanLocation
    hubname: vhubname
    hubaddressprefix: '10.10.0.0/24'
    wanid: vwan.outputs.id
  }
}

output hubVnetRG string = hubrg.name
output vwanRG string = vwanrg.name
output vwanID string = vwan.outputs.id
