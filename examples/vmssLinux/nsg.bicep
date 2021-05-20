param networkSecurityGroupName string
param networkSecurityGroupLocation string
param startPort int
param endPort int
param natBackendPort int

resource nsg 'Microsoft.Network/networkSecurityGroups@2020-06-01' = {
  name: networkSecurityGroupName
  location: networkSecurityGroupLocation
  properties: {
    securityRules: [
      {
        name: 'SSH'
        properties: {
          priority: 1000
          protocol: 'Tcp'
          access: 'Allow'
          direction: 'Inbound'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '22'
        }
      }
      {
        name: 'customRules'
        properties: {
          priority: 999
          protocol: 'Tcp'
          access: 'Allow'
          direction: 'Inbound'
          sourceAddressPrefix: '*'
          sourcePortRange: '${startPort}-${endPort}'
          destinationAddressPrefix: '*'
          destinationPortRange: '${natBackendPort}'
        }
      }
    ]
  }
}

output nsgID string = nsg.id
