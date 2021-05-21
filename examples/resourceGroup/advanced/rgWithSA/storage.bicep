@minLength(3)
@maxLength(11)
param storagePrefix string

@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_RAGRS'
  'Standard_ZRS'
  'Premium_LRS'
  'Premium_ZRS'
  'Standard_GZRS'
  'Standard_RAGZRS'
])
param storageSKU string = 'Standard_LRS'

param location string = resourceGroup().location

param globalRedundancy bool = true // defaults to true, but can be overridden

//param containerName string = 'container1'

var uniqueStorageName = '${storagePrefix}${uniqueString(resourceGroup().id)}'
var containerName = 'container1-${uniqueString(resourceGroup().id)}'


resource stg 'Microsoft.Storage/storageAccounts@2019-04-01' = {
  name: uniqueStorageName
  location: location
  sku: {
    name: globalRedundancy ? 'Standard_GRS' : 'Standard_LRS' // if true --> GRS, else --> LRS
  }
  kind: 'StorageV2'
  properties: {
    supportsHttpsTrafficOnly: true
  }
}

resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2019-06-01' = {
  name: '${stg.name}/default/${containerName}'
}
output storageAccountId string = stg.id
output blobEndPoint string = stg.properties.primaryEndpoints.blob
