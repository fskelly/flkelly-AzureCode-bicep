@description('Specifies the name of the vwan instance.')
param vwanName string //= 'wan1'

@description('Specifies the location for the deployment.')
param vwanLocation string //= 'northeurope'

@description('Enable / disable VpnEncryption')
param disableVpnEncryption bool //= false

@description('Enable / disable branch to branch traffic')
param allowBranchToBranchTraffic bool //= true

@description('Enable / disable vnet to vnet traffic')
param allowVnetToVnetTraffic bool //= true

@allowed([
  'Standard'
  'Basic'
])
@description('vwan hub SKU')
param vwantype string = 'Standard'

param resourceTags object

resource virtualWan 'Microsoft.Network/virtualWans@2020-07-01' = {
  name: vwanName
  location: vwanLocation
  tags: resourceTags
  properties: any({
    type: vwantype
    disableVpnEncryption: disableVpnEncryption
    allowBranchToBranchTraffic: allowBranchToBranchTraffic
    allowVnetToVnetTraffic: allowVnetToVnetTraffic
    office365LocalBreakoutCategory: 'Optimize'
  })
}

output vWanID string = virtualWan.id
