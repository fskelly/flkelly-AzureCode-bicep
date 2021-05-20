param connectionName string
param connectionLocation string = resourceGroup().location
param sharedKey string
param virtualNetworkGatewayNameId string
param localNetworkGatewayNameId string

resource connectionName_resource 'Microsoft.Network/connections@2018-07-01' = {
  name: connectionName
  location: connectionLocation
  properties: {
    virtualNetworkGateway1: {
      id: virtualNetworkGatewayNameId
    }
    localNetworkGateway2: {
      id: localNetworkGatewayNameId
    }
    connectionType: 'IPsec'
    routingWeight: 10
    sharedKey: sharedKey
  }
}
