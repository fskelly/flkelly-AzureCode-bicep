// Control parameters
param deployKV bool

// Resource Group parameters
param rgName string
param rgLocation string
param createRg bool

// Storage Account parameters
param storageAccountPrefix string = 'st'
var storageAccountName = '${storageAccountPrefix}${uniqueString(rgName)}'

// Keyvault parameters
param vaultNamePrefix string = 'kv'
// var rgID = createRg ? resource_group.id : existingRg.id
var vaultName = '${vaultNamePrefix}${uniqueString(existingRg.id)}'
param location string = rgLocation
param sku string = 'Standard'
param objectID string
param tenantID string //= '' replace with your tenantId
param accessPolicies array = [
  {
    tenantId: tenantID
    objectId: objectID // replace with your objectId
    permissions: {
      keys: [
        'Get'
        'List'
        'Update'
        'Create'
        'Import'
        'Delete'
        'Recover'
        'Backup'
        'Restore'
      ]
      secrets: [
        'Get'
        'List'
        'Set'
        'Delete'
        'Recover'
        'Backup'
        'Restore'
      ]
      certificates: [
        'Get'
        'List'
        'Update'
        'Create'
        'Import'
        'Delete'
        'Recover'
        'Backup'
        'Restore'
        'ManageContacts'
        'ManageIssuers'
        'GetIssuers'
        'ListIssuers'
        'SetIssuers'
        'DeleteIssuers'
      ]
    }
  }
]
param enabledForDeployment bool = true
param enabledForTemplateDeployment bool = true
param enabledForDiskEncryption bool = true
param enableRbacAuthorization bool = false
param softDeleteRetentionInDays int = 90
param enableSoftDelete bool = false
param networkAcls object = {
  ipRules: []
  virtualNetworkRules: []
}
//keyvault secret parameters
@secure()
param userName string
@secure()
param userPassword string
// Global parameters
targetScope = 'subscription'

// var rgID = createRg ? resource_group.id : existingRg.id

// resource resource_group 'Microsoft.Resources/resourceGroups@2021-04-01' = if (createRg) {   
//     name: rgName
//     location: rgLocation
// }

resource existingRg 'Microsoft.Resources/resourceGroups@2021-04-01' existing = if (!createRg) {
  name: rgName
}

// Variable to reference the resource group
// var rgReference = createRg ? resource_group : existingRg

module storageAccountModule './storageAccount/storageAccount.bicep' = {
    name: 'deploy-storage-account'
    scope: resourceGroup(rgName)
    params: {
      storageAccountName: storageAccountName
      location: rgLocation
    }
    dependsOn: [existingRg]
}
  
module keyVaultModule './azureKeyVault/kv.bicep' = if (deployKV){
  name: 'deploy-keyvault'
  scope: resourceGroup(rgName)
  params: {
    objectID: objectID
    accessPolicies: accessPolicies
    enabledForDeployment: enabledForDeployment
    enabledForDiskEncryption: enabledForDiskEncryption
    enabledForTemplateDeployment: enabledForTemplateDeployment
    enableRbacAuthorization: enableRbacAuthorization
    enableSoftDelete: enableSoftDelete
    location: location
    networkAcls: networkAcls
    sku: sku
    softDeleteRetentionInDays: softDeleteRetentionInDays
    tenantID: tenantID
    vaultName: vaultName
  }
  
}

module keyVaultSecretModule './azureKeyVault/keyVaultSecret.bicep' = if (deployKV) {
  name: 'deploy-keyvault-secrets'
  scope: resourceGroup(rgName)
  params: {
    userName: userName
    userPassword: userPassword
    vaultName: keyVaultModule.outputs.keyVaultName
    userNameValue: 'domain-admin-username'
    userPasswordValue: 'domain-admin-password'
  }
}

// outputs
output rgName string = rgName
output rgID string = existingRg.id
output rgLocation string = rgLocation
output storageAccountName string = storageAccountModule.outputs.storageAccountName
output storageAccountId string = storageAccountModule.outputs.storageAccountId
output keyVaultName string = deployKV ? keyVaultModule.outputs.keyVaultName : ''
output keyVaultId string = deployKV ? keyVaultModule.outputs.keyVaultId : ''
