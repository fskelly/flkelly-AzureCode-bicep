param virtualWanName string
param virtualWanLocation string
param virtualWanType string = 'Standard'

resource virtualWan 'Microsoft.Network/virtualWans@2020-07-01' = {
  name: virtualWanName
  location: virtualWanLocation
  properties: any({
    type: virtualWanType
    disableVpnEncryption: false
    allowBranchToBranchTraffic: true
    allowVnetToVnetTraffic: true
    office365LocalBreakoutCategory: 'Optimize'
    hubRoutingPreference: 'VPN'
  })
}

output virtualWanId string = virtualWan.id

