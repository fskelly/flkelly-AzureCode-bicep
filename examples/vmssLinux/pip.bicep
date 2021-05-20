param publicIPAddressName string
param publicIPAddressLocation string = resourceGroup().location
param longNamingInfix string

resource publicIP 'Microsoft.Network/publicIPAddresses@2020-06-01' = {
  name: publicIPAddressName
  location: publicIPAddressLocation
  properties: {
    publicIPAllocationMethod: 'Dynamic'
    dnsSettings: {
      domainNameLabel: longNamingInfix
    }
  }
}

output pipID string = publicIP.id
