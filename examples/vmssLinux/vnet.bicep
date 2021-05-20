param virtualNetworkName string
param vnetLocation string = resourceGroup().location
param addressPrefix string
param subnetName string
param subnetPrefix string
param nsgID string

resource virtualNetwork 'Microsoft.Network/virtualnetworks@2015-05-01-preview' = {
  name: virtualNetworkName
  location: vnetLocation
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: subnetPrefix
          networkSecurityGroup:{
            id: nsgID
          }
        }
      }
    ]
    
  }
}

output vnetID string = virtualNetwork.id
output subnetName string = virtualNetwork.properties.subnets[0].name
