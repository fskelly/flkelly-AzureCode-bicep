targetScope = 'subscription'

var rgName = '${namePrefix}-${suffix}'

param namePrefix string
param suffix string
param rgLocation string

resource rg 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: rgName
  location: rgLocation
}

output rgName string = rg.name
