param virtualNetworkGatewayLocation string = resourceGroup().location
param virtualNetworkGatewayName string
param gatewaySku string
param vpnType string
param gatewaySubnetRef string
param gatewayPublicIPName_resourceId string
param enableBGP bool

resource gatewayName_resource 'Microsoft.Network/virtualNetworkGateways@2015-06-15' = {
  name: virtualNetworkGatewayName
  location: virtualNetworkGatewayLocation
  properties: {
    ipConfigurations: [
      {
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: gatewaySubnetRef
          }
          publicIPAddress: {
            id: gatewayPublicIPName_resourceId
          }
        }
        name: 'vnetGatewayConfig'
      }
    ]
    sku: {
      name: gatewaySku
      tier: gatewaySku
    }
    gatewayType: 'Vpn'
    vpnType: vpnType
    enableBgp: enableBGP
  }
}

output virtualNetworkGatewayId string = gatewayName_resource.id
output virtualNEtworkGatewayPIPId string = gatewayPublicIPName_resourceId
