@description('Specifies the name of the virtual network.')
param vnetName string //= 'vnet1'

@description('Specifies the location of the virtual network.')
param vnetLocation string //= 'northeurope'

@description('Specifies the CIDR of the virtual network.')
param vnetCIDR string //= '172.16.10.0/24'

@description('Specifies the name of the subnet.')
param snetName string //= 'snet1'

@description('Specifies the CIDR of the subnet.')
param snetCIDR string //= ''172.16.10.0/26''

@description('Specifies the tags top be added to the resources.')
param resourceTags object

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: vnetName
  location: vnetLocation
  tags: resourceTags
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetCIDR
      ]
    }
    subnets: [
      {
        name: snetName
        properties: {
          addressPrefix: snetCIDR
        }
      }
    ]
  }
}

output vnetID string = virtualNetwork.id
