@description('Specifies the name of the virtual hub instance.')
param hubName string //= 'wan1'

@description('Specifies the location for the deployment.')
param vwanHubLocation string //= 'northeurope'

@description('Specifies the IP CIDR for the vWan Hub.')
param vwanHubAddressPrefix string //= '10.10.10.0/24'

@description('Specifies the ID for the vWan.')
param vwanID string

@description('Specifies the tags top be added to the resources.')
param resourceTags object

resource virtualWanHub 'Microsoft.Network/virtualHubs@2020-06-01' = {
  name: hubName
  location: vwanHubLocation
  tags: resourceTags
  properties: {
    addressPrefix: vwanHubAddressPrefix
    virtualWan: {
      id: vwanID
    }
  }
}

output hubID string = virtualWanHub.id
