param location string = 'eastus'
param workspaceName string = 'bicep-wvd-workspace'
param hostpoolName string = 'bicep-wvd-hostpool'
param appgroupName string = 'bicep-wvd-appgroup'
param preferredAppGroupType string = 'Desktop'
param hostPoolType string = 'pooled'
param loadbalancertype string = 'BreadthFirst'
param appgroupType string = 'Desktop'

resource hostpoolName_resource 'Microsoft.DesktopVirtualization/hostPools@2019-12-10-preview' = {
  name: hostpoolName
  location: location
  properties: {
    friendlyName: 'My Bicep generated Host pool'
    hostPoolType: hostPoolType
    loadBalancerType: loadbalancertype
    preferredAppGroupType: preferredAppGroupType
  }
}

resource appgroupName_resource 'Microsoft.DesktopVirtualization/applicationGroups@2019-12-10-preview' = {
  name: appgroupName
  location: location
  properties: {
    friendlyName: 'My Bicep generated application Group'
    applicationGroupType: appgroupType
    hostPoolArmPath: hostpoolName_resource.id
  }
}

resource workspaceName_resource 'Microsoft.DesktopVirtualization/workspaces@2019-12-10-preview' = {
  name: workspaceName
  location: location
  properties: {
    friendlyName: 'My Bicep generated Workspace'
    applicationGroupReferences: [
      appgroupName_resource.id
    ]
  }
}

output workspaceid string = workspaceName_resource.id