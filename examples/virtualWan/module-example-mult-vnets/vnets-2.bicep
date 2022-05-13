@description('Specifies the location of the virtual network.')
param vnetLocation string //= 'northeurope'

@description('Specifies the tags top be added to the resources.')
param resourceTags object

param vnetCount int //= 2

@batchSize(1)

resource vnet 'Microsoft.Network/virtualNetworks@2020-06-01' = [for i in range(1,vnetCount): {
  tags: resourceTags
  name: 'landingzone-${i}-vnet'
  location: vnetLocation
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.${i}.0.0/24'
      ]
    }
    subnets: [ 
      {
        name: 'landingzone-${i}-subnet1'
        properties: {
          addressPrefix: '10.${i}.0.0/26'
        }
      }

    ]
  }
}]

output deployedVnets array = [for i in range(1,vnetCount): {
  vnetId: vnet[i].id
}]
