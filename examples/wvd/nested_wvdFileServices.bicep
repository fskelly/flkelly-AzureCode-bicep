param storageaccountlocation string = 'westeurope'
param storageaccountName string
param storageaccountkind string
param storgeaccountglobalRedundancy string = 'Premium_LRS'
param fileshareFolderName string = 'profilecontainers'

var filesharelocation_var = '${storageaccountName}/default/${fileshareFolderName}'

resource storageaccountName_resource 'Microsoft.Storage/storageAccounts@2020-08-01-preview' = {
  name: storageaccountName
  location: storageaccountlocation
  kind: storageaccountkind
  sku: {
    name: storgeaccountglobalRedundancy
  }
}

resource filesharelocation 'Microsoft.Storage/storageAccounts/fileServices/shares@2020-08-01-preview' = {
  name: filesharelocation_var
  dependsOn: [
    storageaccountName_resource
  ]
}