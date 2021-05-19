param logAnalyticsWorkspaceID string
param hostpoolName string
param workspaceName string

resource hostpool_diag 'microsoft.insights/diagnosticSettings@2017-05-01-preview' = {
  name: 'hostpool-diag'
  properties: {
    workspaceId: logAnalyticsWorkspaceID
    logs: [
      {
        category: 'Checkpoint'
        enabled: true
      }
      {
        category: 'Error'
        enabled: true
      }
      {
        category: 'Management'
        enabled: true
      }
      {
        category: 'Connection'
        enabled: true
      }
      {
        category: 'HostRegistration'
        enabled: true
      }
    ]
  }
  scope: 'Microsoft.DesktopVirtualization/hostPools/${hostpoolName}'
  dependsOn: []
}

resource workspacepool_diag 'microsoft.insights/diagnosticSettings@2017-05-01-preview' = {
  name: 'workspacepool-diag'
  properties: {
    workspaceId: logAnalyticsWorkspaceID
    logs: [
      {
        category: 'Checkpoint'
        enabled: true
      }
      {
        category: 'Error'
        enabled: true
      }
      {
        category: 'Management'
        enabled: true
      }
      {
        category: 'Feed'
        enabled: true
      }
    ]
  }
  scope: 'Microsoft.DesktopVirtualization/hostPools/${hostpoolName}'
  dependsOn: []
}