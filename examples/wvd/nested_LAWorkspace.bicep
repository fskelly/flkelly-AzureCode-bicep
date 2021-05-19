param logAnalyticsWorkspaceName string
param logAnalyticslocation string = 'westeurope'
param logAnalyticsWorkspaceSku string = 'pergb2018'
param hostpoolName string
param workspaceName string
param logAnalyticsResourceGroup string
param wvdBackplaneResourceGroup string

resource logAnalyticsWorkspaceName_resource 'Microsoft.OperationalInsights/workspaces@2020-08-01' = {
  name: logAnalyticsWorkspaceName
  location: logAnalyticslocation
  properties: {
    sku: {
      name: logAnalyticsWorkspaceSku
    }
  }
}

module myBicepLADiag './nested_myBicepLADiag.bicep' = {
  name: 'myBicepLADiag'
  scope: resourceGroup(wvdBackplaneResourceGroup)
  params: {
    logAnalyticsWorkspaceID: logAnalyticsWorkspaceName_resource.id
    hostpoolName: hostpoolName
    workspaceName: workspaceName
  }
}