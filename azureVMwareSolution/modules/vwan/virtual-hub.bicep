param vwan1Hub1Name string = 'Hub1'
param vwan1Hub1Prefix string = '192.168.200.0/24'
param vwan1Hub1Location string // = 'westeurope'
param vwan1Id string
//param location string = resourceGroup().location

resource VwanHub1 'Microsoft.Network/virtualHubs@2021-02-01' = {
  name: vwan1Hub1Name
  location: vwan1Hub1Location
  properties: {
    allowBranchToBranchTraffic: true
    preferredRoutingGateway: 'VpnGateway'
    virtualWan: {
      id: vwan1Id
    }
    addressPrefix: vwan1Hub1Prefix

  }
}
