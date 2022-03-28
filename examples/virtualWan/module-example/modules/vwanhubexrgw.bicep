@description('Specifies the name of the virtual hub instance.')
param hubExpressRouteGatewayName string //= 'wan1'

@description('Specifies the location for the deployment.')
param vwanHubLocation string //= 'northeurope'

@description('Specifies the ID for the vWan.')
param virtualHubID string

@description('Specifies the tags top be added to the resources.')
param resourceTags object

resource virtualWanHubExrGateway 'Microsoft.Network/expressRouteGateways@2021-05-01' = {
  name: hubExpressRouteGatewayName
  location: vwanHubLocation
  tags: resourceTags
  properties: {
    autoScaleConfiguration: {
      bounds: {
        min: 1
      }
    }
    virtualHub: {
      id: virtualHubID
    }
  }
}
