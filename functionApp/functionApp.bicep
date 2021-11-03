// This example deploys an Azure Function app and an HTTP-triggered function inline in the template.
// It also deploys a Key Vault and populates a secret with the function app's host key.

param location string = resourceGroup().location
param appNameSuffix string = uniqueString(resourceGroup().id)
param keyVaultSku string = 'Standard'

var functionAppName = 'fn-${appNameSuffix}'
var appServicePlanName = 'FunctionPlan'
var appInsightsName = 'AppInsights'
var storageAccountName = 'fnstor${replace(appNameSuffix, '-', '')}'
var functionNameComputed = 'MyHttpTriggeredFunction1'
var functionRuntime = 'powershell'
var keyVaultName = 'kv${replace(appNameSuffix, '-', '')}'
var functionAppKeySecretName = 'FunctionAppHostKey'

resource storageAccount 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    supportsHttpsTrafficOnly: true
    encryption: {
      services: {
        file: {
          keyType: 'Account'
          enabled: true
        }
        blob: {
          keyType: 'Account'
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
    accessTier: 'Hot'
  }
}

resource appInsights 'Microsoft.Insights/components@2018-05-01-preview' = {
  name: appInsightsName
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
  }
}

resource plan 'Microsoft.Web/serverFarms@2020-06-01' = {
  name: appServicePlanName
  location: location
  kind: 'functionapp'
  sku: {
    name: 'Y1'
  }
  properties: {}
}

resource functionApp 'Microsoft.Web/sites@2020-06-01' = {
  name: functionAppName
  location: location
  kind: 'functionapp'
  properties: {
    serverFarmId: plan.id
    siteConfig: {
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storageAccount.listKeys().keys[0].value}'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storageAccount.listKeys().keys[0].value}'
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: appInsights.properties.InstrumentationKey
        }
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: 'InstrumentationKey=${appInsights.properties.InstrumentationKey}'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: functionRuntime
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~3'
        }
      ]
    }
    httpsOnly: true
  }
}

resource function 'Microsoft.Web/sites/functions@2020-06-01' = {
  name: '${functionApp.name}/${functionNameComputed}'
  properties: {
    config: {
      disabled: false
      bindings: [
        {
          name: 'req'
          type: 'httpTrigger'
          direction: 'in'
          authLevel: 'function'
          methods: [
            'get'
          ]
        }
        {
          name: '$return'
          type: 'http'
          direction: 'out'
        }
      ]
    }
    files: {
    'run.ps1': '''
      using namespace System.Net

      # Input bindings are passed in via param block.
      param($Request, $TriggerMetadata)
      
      # Write to the Azure Functions log stream.
      Write-Host "PowerShell HTTP trigger function processed a request."
      
      # Interact with query parameters or the body of the request.
      $tagName = $Request.Query.tagName
      if (-not $tagName) {
          $tagName = $Request.Body.tagName
      }
      $tagValue = $Request.Query.tagValue
      if (-not $tagValue) {
          $tagValue = $Request.Body.tagValue
      }
      
      $body = "This HTTP triggered function executed successfully. Pass a name in the query string or in the request body for a personalized response."
      
      Import-Module Az.ResourceGraph
      
      $statusGood = $true
      
      $graphQuery = "resourcecontainers | where type == 'microsoft.resources/subscriptions/resourcegroups' | project  name,type,location,subscriptionId,tags | union (resources | project name,type,location,subscriptionId,tags) | mv-expand  tags| extend tagKey = tostring(bag_keys(tags)[0]) | extend tagValue = tostring(tags[tagKey]) | where tagKey =~ '$tagName' and tagValue  =~ '$tagValue'"
      
      try {
              $taggedResources = Search-AzGraph -Query $graphQuery
              $taggedResourcesCount = $taggedResources.count
          }
      catch {
              $statusGood = $false
              Write-Error "Failure running Search-AzGraph, $_"
          }
          
      if($statusGood)
      {
          #$status = [HttpStatusCode]::OK
          if ($taggedResourcesCount -ge 1){
              $taggedResourcesJson = ConvertTo-Json $taggedResources
              $status = [HttpStatusCode]::OK; 
          } else {
              $taggedResourcesJson = "{`"result`": `"Nothing found by query`", `"query`": `"$graphQuery`"}";
              $status = [HttpStatusCode]::OK;
          }
      } else {
          $taggedResourcesJson = "{`"Status`": `"Failed`"}"
          $status = [HttpStatusCode]::BadRequest
      }
      
      # Associate values to output bindings by calling 'Push-OutputBinding'.
      Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
          StatusCode = $status
      
          Body = $taggedResourcesJson  #+ $graphQuery
      })
      
    '''
    }
  }
}

resource keyVault 'Microsoft.KeyVault/vaults@2019-09-01' = {
  name: keyVaultName
  location: location
  properties: {
    tenantId: subscription().tenantId
    sku: {
      family: 'A'
      name: keyVaultSku
    }
    accessPolicies: []
  }
}

resource keyVaultSecret 'Microsoft.KeyVault/vaults/secrets@2018-02-14' = {
  name: '${keyVault.name}/${functionAppKeySecretName}'
  properties: {
    value: listKeys('${functionApp.id}/host/default', functionApp.apiVersion).functionKeys.default
  }
}

output functionAppHostName string = functionApp.properties.defaultHostName
output functionName string = functionNameComputed
