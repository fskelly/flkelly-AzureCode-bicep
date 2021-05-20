param storageAccountName string // need to be provided since it is existing

param containerNames array = [
  'dogs'
  'cats'
  'fish'
  'hamsters'
  'snake'
]

resource stg 'Microsoft.Storage/storageAccounts@2019-06-01' existing = {
  name: storageAccountName
}

resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2019-06-01' = [for name in containerNames: {
  name: '${stg.name}/default/${name}'
  // dependsOn will be added when the template is compiled
}]

output storageAccountId string = stg.id
output blobEndPoint string = stg.properties.primaryEndpoints.blob
output containerProps array = [for i in range(0, length(containerNames)): container[i].id]
