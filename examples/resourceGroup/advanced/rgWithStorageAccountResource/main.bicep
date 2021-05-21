param baseName string
param rgLocation string
param storagePrefix string

param resourceTags object = {
  Environment: 'Dev'
  Project: 'Tutorial'
}

targetScope = 'subscription'

resource rg 'Microsoft.Resources/resourceGroups@2020-06-01' ={
  name: '${baseName}-${rgLocation}-rg'
  location: rgLocation
  tags: resourceTags
}

module storageResources './storage.bicep' ={
  name: '${rg.name}-${rgLocation}-resources'
  scope: rg
  params: {
    storagePrefix: storagePrefix
    storageSKU: 'Standard_LRS'
    location: rg.location
    globalRedundancy: true
  }
}
