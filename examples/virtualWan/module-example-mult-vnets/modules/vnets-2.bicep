param vnetCount int = 5
@batchSize(1)

resource vnet 'Microsoft.Network/virtualNetworks@2020-06-01' = [for i in range(1,vnetCount): {
  name: 'landingzone-${i}-vnet'
  location: resourceGroup().location
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

    // subnets: [
    //   {
    //     name: 'frontend'
    //     properties: {
    //       addressPrefix: '10.${i}.0.0/26'
    //     }
    //   }
    //   {
    //     name: 'backend'
    //     properties: {
    //       addressPrefix: '10.${i}.64.0/26'
    //     }
    //   }
    //   {
    //     name: 'appservice'
    //     properties: {
    //       addressPrefix: '10.${i}.128.0/26'
    //     }
    //   }
    // ]
