targetScope = 'subscription'

@description('Name of the resourceGroup to create')
param rgName string

@description('Location for the resourceGroup')
param rgLocation string

resource rg 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: rgName
  location: rgLocation
}
