@description('Specifies the name of the virtual hub instance.')
param vwanHubGatewayName string //= 'wan1'

@description('Specifies the location for the deployment.')
param vwanHubLocation string //= 'northeurope'

@description('Specifies the ID for the Virtual Wan Hub.')
param vwanHubID string //= 'northeurope'

@description('Specifies the tags top be added to the resources.')
param resourceTags object

resource virtualWanHubVpngw 'Microsoft.Network/vpnGateways@2020-06-01' = {
  name: vwanHubGatewayName
  location: vwanHubLocation
  tags: resourceTags
  properties: {
    virtualHub: {
      id: vwanHubID
    }
    //bgpSettings: {
    //  asn: asn
    //}
  }
}

