//@description('Specifies the name of the virtual hub instance.')
//param hubName string //= 'wan1'

@description('Specifies the vnet name for vnet connection.')
param vnetName string

@description('Specifies the vnet ID for vnet connection.')
param vnetID string

param virtualWanHubName string

resource virtualWanHub 'Microsoft.Network/virtualHubs@2020-06-01' existing  = {
  name: virtualWanHubName
}

resource vnetconnection 'Microsoft.Network/virtualHubs/hubVirtualNetworkConnections@2021-05-01' = {
  //name: 'deploy-vnetconnection'
  name: '${virtualWanHubName}-${vnetName}'
  parent: virtualWanHub
  properties: {
    allowHubToRemoteVnetTransit: true
    allowRemoteVnetToUseHubVnetGateways: true
    enableInternetSecurity: false
    remoteVirtualNetwork: {
      id: vnetID
    }
//   routingConfiguration: {
/*       associatedRouteTable: {
        id: 'string'
      } */
/*       propagatedRouteTables: {
        ids: [
          {
            id: 'string'
          }
        ]
        labels: [
          'string'
        ]
      } */
/*       vnetRoutes: {
        staticRoutes: [
          {
            addressPrefixes: [
              'string'
            ]
            name: 'string'
            nextHopIpAddress: 'string'
          }
        ]
      } */ 
    //}
   }
} 
