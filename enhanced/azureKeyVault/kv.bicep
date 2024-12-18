param vaultName string
param location string
param sku string
param objectID string
param tenantID string
param accessPolicies array
param enabledForDeployment bool
param enabledForTemplateDeployment bool
param enabledForDiskEncryption bool
param enableRbacAuthorization bool
param enableSoftDelete bool
param softDeleteRetentionInDays int
param networkAcls object

resource keyVault 'Microsoft.KeyVault/vaults@2021-04-01-preview' = {
  name: vaultName
  location: location
  properties: {
    sku: {
      family: 'A'
      name: sku
    }
    tenantId: tenantID
    accessPolicies: accessPolicies
    enabledForDeployment: enabledForDeployment
    enabledForTemplateDeployment: enabledForTemplateDeployment
    enabledForDiskEncryption: enabledForDiskEncryption
    enableRbacAuthorization: enableRbacAuthorization
    enableSoftDelete: enableSoftDelete
    softDeleteRetentionInDays: softDeleteRetentionInDays
    networkAcls: networkAcls
  }
}

output keyVaultName string = keyVault.name
output keyVaultId string = keyVault.id
