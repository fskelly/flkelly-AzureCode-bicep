param hostpoolName string
param hostpoolFriendlyName string
param appgroupName string
param appgroupNameFriendlyName string
param workspaceName string
param workspaceNameFriendlyName string
param applicationgrouptype string = 'Desktop'
param preferredAppGroupType string = 'Desktop'
param wvdbackplanelocation string = 'eastus'
param hostPoolType string = 'pooled'
param loadBalancerType string = 'BreadthFirst'
param logAnalyticsWorkspaceName string
param logAnalyticslocation string = 'westeurope'
param logAnalyticsWorkspaceSku string = 'pergb2018'
param logAnalyticsResourceGroup string
param wvdBackplaneResourceGroup string

resource hostpoolName_resource 'Microsoft.DesktopVirtualization/hostPools@2019-12-10-preview' = {
  name: hostpoolName
  location: wvdbackplanelocation
  properties: {
    friendlyName: hostpoolFriendlyName
    hostPoolType: hostPoolType
    loadBalancerType: loadBalancerType
    preferredAppGroupType: preferredAppGroupType
  }
}

resource appgroupName_resource 'Microsoft.DesktopVirtualization/applicationGroups@2019-12-10-preview' = {
  name: appgroupName
  location: wvdbackplanelocation
  properties: {
    friendlyName: appgroupNameFriendlyName
    applicationGroupType: applicationgrouptype
    hostPoolArmPath: hostpoolName_resource.id
  }
}

resource workspaceName_resource 'Microsoft.DesktopVirtualization/workspaces@2019-12-10-preview' = {
  name: workspaceName
  location: wvdbackplanelocation
  properties: {
    friendlyName: workspaceNameFriendlyName
    applicationGroupReferences: [
      appgroupName_resource.id
    ]
  }
}

module LAWorkspace './nested_LAWorkspace.bicep' = {
  name: 'LAWorkspace'
  scope: resourceGroup(logAnalyticsResourceGroup)
  params: {
    logAnalyticsWorkspaceName: logAnalyticsWorkspaceName
    logAnalyticslocation: logAnalyticslocation
    logAnalyticsWorkspaceSku: logAnalyticsWorkspaceSku
    hostpoolName: hostpoolName
    workspaceName: workspaceName
    logAnalyticsResourceGroup: logAnalyticsResourceGroup
    wvdBackplaneResourceGroup: wvdBackplaneResourceGroup
  }
  dependsOn: [
    hostpoolName_resource
    workspaceName_resource
  ]
}