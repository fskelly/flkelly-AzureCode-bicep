param localNetworkGatewayLocation string = resourceGroup().location
param localNetworkCIDR array
param LocalNetworkGatewayPIP string
param localGatewayName string

resource localGatewayName_resource 'Microsoft.Network/localNetworkGateways@2018-07-01' = {
  name: localGatewayName
  location: localNetworkGatewayLocation
  properties: {
    localNetworkAddressSpace: {
      addressPrefixes: localNetworkCIDR
    }
    gatewayIpAddress: LocalNetworkGatewayPIP
  }
}

output localNetworkGatewayID string = localGatewayName_resource.id
