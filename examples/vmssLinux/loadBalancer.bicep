param loadBalancerName string
param loadBalancerLocation string = resourceGroup().location
param publicIPId string
param bePoolName string
param natPoolName string
param natStartPort int
param natEndPort int
param natBackendPort int

resource loadBalancer 'Microsoft.Network/loadBalancers@2020-06-01' = {
  name: loadBalancerName
  location: loadBalancerLocation
  properties: {
    frontendIPConfigurations: [
      {
        name: 'LoadBalancerFrontEnd'
        properties: {
          publicIPAddress: {
            id: publicIPId
          }
        }
      }
    ]
    backendAddressPools: [
      {
        name: bePoolName
      }
    ]
    inboundNatPools: [
      {
        name: natPoolName
        properties: {
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', loadBalancerName, 'loadBalancerFrontEnd')
          }
          protocol: 'Tcp'
          frontendPortRangeStart: natStartPort
          frontendPortRangeEnd: natEndPort
          backendPort: natBackendPort
        }
      }
    ]
  }
} 

output loadBalancerID string = loadBalancer.id
output bePoolName string = loadBalancer.properties.backendAddressPools[0].name
output natPoolName string = loadBalancer.properties.inboundNatPools[0].name
