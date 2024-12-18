# Azure Bicep Deployment

This repository contains Bicep files for deploying Azure resources, including a Resource Group, Storage Account, and Key Vault.

## Bicep Files

### `main.bicep`

The `main.bicep` file is the entry point for the deployment. It handles the creation of a Resource Group if it does not exist and deploys a Storage Account and Key Vault within the Resource Group.

#### Parameters

- `rgName`: The name of the Resource Group.
- `rgLocation`: The location of the Resource Group.
- `createRg`: A boolean indicating whether to create the Resource Group.
- `storageAccountName`: The name of the Storage Account.
- `vaultName`: The name of the Key Vault (optional, defaults to a unique name).
- `location`: The location for the Key Vault (defaults to the Resource Group location).
- `sku`: The SKU for the Key Vault (defaults to 'Standard').
- `objectID`: The object ID for access policies.
- `tenantID`: The tenant ID for access policies.
- `accessPolicies`: An array of access policies for the Key Vault.
- `enabledForDeployment`: A boolean indicating whether the Key Vault is enabled for deployment (defaults to true).
- `enabledForTemplateDeployment`: A boolean indicating whether the Key Vault is enabled for template deployment (defaults to true).
- `enabledForDiskEncryption`: A boolean indicating whether the Key Vault is enabled for disk encryption (defaults to true).
- `enableRbacAuthorization`: A boolean indicating whether RBAC authorization is enabled (defaults to false).
- `softDeleteRetentionInDays`: The number of days to retain soft-deleted items (defaults to 90).
- `enableSoftDelete`: A boolean indicating whether soft delete is enabled (defaults to false).
- `networkAcls`: Network ACLs for the Key Vault.

### `storageAccount.bicep`

The `storageAccount.bicep` file defines the Storage Account resource.

#### Parameters

- `storageAccountName`: The name of the Storage Account.
- `location`: The location for the Storage Account.
- `skuName`: The SKU for the Storage Account (defaults to 'Standard_LRS').
- `kind`: The kind of the Storage Account (defaults to 'StorageV2').

### `kv.bicep`

The `kv.bicep` file defines the Key Vault resource.

#### Parameters

- `vaultName`: The name of the Key Vault.
- `location`: The location for the Key Vault.
- `sku`: The SKU for the Key Vault.
- `objectID`: The object ID for access policies.
- `tenantID`: The tenant ID for access policies.
- `accessPolicies`: An array of access policies for the Key Vault.
- `enabledForDeployment`: A boolean indicating whether the Key Vault is enabled for deployment.
- `enabledForTemplateDeployment`: A boolean indicating whether the Key Vault is enabled for template deployment.
- `enabledForDiskEncryption`: A boolean indicating whether the Key Vault is enabled for disk encryption.
- `enableRbacAuthorization`: A boolean indicating whether RBAC authorization is enabled.
- `enableSoftDelete`: A boolean indicating whether soft delete is enabled.
- `softDeleteRetentionInDays`: The number of days to retain soft-deleted items.
- `networkAcls`: Network ACLs for the Key Vault.

## Deployment

To deploy the resources, use the following PowerShell script:

```powershell
$rgName = read-host "Enter the name of the resource group to be created."
$rgLocation = read-host "Enter the location for the resource group."
$tenantID = read-host "Enter the tenant ID."
$objectID = read-host "Enter the object ID."

$rg = Get-AzResourceGroup -Name $rgName -ErrorAction SilentlyContinue

$createRg = $false
if (-not $rg) {
    Write-Output "Resource group $rgName not found anywhere - deploying $rgName in $rgLocation."
    $createRg = $true
} elseif ($rg.Location -ne $rgLocation) {
    Write-Output "Resource group $rgName exists in a different location ($($rg.Location)). Please use the correct location."
    exit 1
} else {
    Write-Output "Resource group $rgName already exists in the correct location. Continuing..."
}

$bicepFile = ".\main.bicep"
$deploymentName = "main.bicep-deployment"
New-AzSubscriptionDeployment -TemplateFile $bicepFile -Location $rgLocation -Name $deploymentName -rgName $rgName -rgLocation $rgLocation -createRg $createRg -tenant $tenantID -objectID $objectID -verbose