// Resource Group parameters
param rgName string
param rgLocation string
param createRg bool

//Storage Account parameters
param storageAccountName string

targetScope = 'subscription'

resource resource_group 'Microsoft.Resources/resourceGroups@2021-04-01' = if (createRg) {   
    name: rgName
    location: rgLocation
}

module storageAccountModule './storageAccount/storageAccount.bicep' = {
    name: 'storageAccountDeployment'
    scope: resourceGroup(rgName)
    params: {
      storageAccountName: storageAccountName
      location: rgLocation
    }
  }
  


// output
output rgName string = rgName
output rgLocation string = rgLocation
