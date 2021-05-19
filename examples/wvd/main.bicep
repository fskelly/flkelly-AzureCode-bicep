targetScope = 'subscription'
param resourceGroupPrefrix string = 'flkelly-weu-bicep-wvd-'
param hostpoolName string = 'myBicepHostpool'
param hostpoolFriendlyName string = 'My Bicep deployed Hostpool'
param appgroupName string = 'myBicepAppGroup'
param appgroupNameFriendlyName string = 'My Bicep deployed Appgroup'
param workspaceName string = 'myBicepWorkspace'
param workspaceNameFriendlyName string = 'My Bicep deployed Workspace'
param preferredAppGroupType string = 'Desktop'
param wvdbackplanelocation string = 'eastus'
param hostPoolType string = 'pooled'
param loadBalancerType string = 'BreadthFirst'
param logAnalyticsWorkspaceName string = 'flkelly-weu-azuremonitor'
param vnetName string = 'bicep-vnet'
param vnetaddressPrefix string = '10.0.0.0/15'
param subnetPrefix string = '10.0.1.0/24'
param vnetLocation string = 'westeurope'
param subnetName string = 'bicep-subnet'
param storageaccountlocation string = 'westeurope'
param storageaccountName string = 'bicepsa'
param storageaccountkind string = 'FileStorage'
param storgeaccountglobalRedundancy string = 'Premium_LRS'
param fileshareFolderName string = 'profilecontainers'

resource 0_BACKPLANE_resourceGroupPrefrix 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: '${resourceGroupPrefrix}BACKPLANE'
  location: 'westeurope'
}

resource 0_NETWORK_resourceGroupPrefrix 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: '${resourceGroupPrefrix}NETWORK'
  location: 'westeurope'
}

resource 0_FILESERVICES_resourceGroupPrefrix 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: '${resourceGroupPrefrix}FILESERVICES'
  location: 'westeurope'
}

resource 0_MONITOR_resourceGroupPrefrix 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: '${resourceGroupPrefrix}MONITOR'
  location: 'westeurope'
}

module wvdbackplane './nested_wvdbackplane.bicep' = {
  name: 'wvdbackplane'
  scope: resourceGroup('${resourceGroupPrefrix}BACKPLANE')
  params: {
    hostpoolName: hostpoolName
    hostpoolFriendlyName: hostpoolFriendlyName
    appgroupName: appgroupName
    appgroupNameFriendlyName: appgroupNameFriendlyName
    workspaceName: workspaceName
    workspaceNameFriendlyName: workspaceNameFriendlyName
    preferredAppGroupType: preferredAppGroupType
    applicationgrouptype: preferredAppGroupType
    wvdbackplanelocation: wvdbackplanelocation
    hostPoolType: hostPoolType
    loadBalancerType: loadBalancerType
    logAnalyticsWorkspaceName: logAnalyticsWorkspaceName
    logAnalyticsResourceGroup: '${resourceGroupPrefrix}MONITOR'
    wvdBackplaneResourceGroup: '${resourceGroupPrefrix}BACKPLANE'
  }
  dependsOn: [
    subscriptionResourceId('Microsoft.Resources/resourceGroups', '${resourceGroupPrefrix}MONITOR')
    subscriptionResourceId('Microsoft.Resources/resourceGroups', '${resourceGroupPrefrix}BACKPLANE')
  ]
}

module wvdnetwork './nested_wvdnetwork.bicep' = {
  name: 'wvdnetwork'
  scope: resourceGroup('${resourceGroupPrefrix}NETWORK')
  params: {
    vnetName: vnetName
    vnetaddressPrefix: vnetaddressPrefix
    subnetPrefix: subnetPrefix
    vnetLocation: vnetLocation
    subnetName: subnetName
  }
  dependsOn: [
    subscriptionResourceId('Microsoft.Resources/resourceGroups', '${resourceGroupPrefrix}NETWORK')
  ]
}

module wvdFileServices './nested_wvdFileServices.bicep' = {
  name: 'wvdFileServices'
  scope: resourceGroup('${resourceGroupPrefrix}FILESERVICES')
  params: {
    storageaccountlocation: storageaccountlocation
    storageaccountName: storageaccountName
    storageaccountkind: storageaccountkind
    storgeaccountglobalRedundancy: storgeaccountglobalRedundancy
    fileshareFolderName: fileshareFolderName
  }
  dependsOn: [
    subscriptionResourceId('Microsoft.Resources/resourceGroups', '${resourceGroupPrefrix}FILESERVICES')
  ]
}