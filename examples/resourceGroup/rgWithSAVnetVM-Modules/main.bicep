param baseName string
param rgLocation string
param storagePrefix string

param resourceTags object = {
  Environment: 'Dev'
  Project: 'Tutorial'
  Deployment: 'Bicep'
  'Can Be Deleted': 'Yes'
}

@allowed([
  'prod'
  'dev'
])
param vmEnvironmentType string

@metadata({
  description: 'password for the windows VM'
})
@secure()
param localAdminPassword string 

targetScope = 'subscription'

resource rg 'Microsoft.Resources/resourceGroups@2020-06-01' ={
  name: '${baseName}-${rgLocation}-rg'
  location: rgLocation
  tags: resourceTags
}

module storageResources './modules/storage.bicep' ={
  name: '${rg.name}-${rgLocation}-storageResources'
  scope: rg
  params: {
    storagePrefix: storagePrefix
    storageSKU: 'Standard_LRS'
    location: rg.location
    globalRedundancy: true
  }
}

module vmResources './modules/vm.bicep' = {
  name: '${rg.name}-${rgLocation}-vmResources'
  scope: rg
  params: {
    localAdminPassword: localAdminPassword
    vmPrefix: 'fsk'
    vmOS: '2016-Datacenter'
    environmentName: vmEnvironmentType
    resourceTags: resourceTags
    virtualNetworkID: networkResources.outputs.vnetID
  }  
}
module networkResources './modules/network.bicep' = {
  name: '${rg.name}-${rgLocation}-networkResources'
  scope: rg
  params: {
    vnetName: '${baseName}-vnet'
    vnetPrefix: '10.0.0.0/24'
  }
}
