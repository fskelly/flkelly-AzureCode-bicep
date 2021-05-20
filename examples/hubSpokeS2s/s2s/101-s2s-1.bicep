@allowed([
  'RouteBased'
  'PolicyBased'
])
@description('Route based or policy based')
param vpnType string = 'RouteBased'

@description('Arbitrary name for gateway resource representing')
param localGatewayName string = 'localGateway'

@description('Public IP of your StrongSwan Instance')
param localGatewayIpAddress string = '1.1.1.1'

@description('CIDR block representing the address space of the OnPremise VPN network\'s Subnet')
param localAddressPrefix array = [
  '192.168.0.0/16'
  '172.16.0.0/12'
]

@description('Arbitrary name for the Azure Virtual Network')
param virtualNetworkName string = 'azureVnet'

@description('CIDR block representing the address space of the Azure VNet')
param azureVNetAddressPrefix string = '10.3.0.0/16'

@description('Arbitrary name for the Azure Subnet')
param subnetName string = 'Subnet1'

@description('CIDR block for VM subnet, subset of azureVNetAddressPrefix address space')
param subnetPrefix string = '10.3.1.0/24'

@description('CIDR block for gateway subnet, subset of azureVNetAddressPrefix address space')
param gatewaySubnetPrefix string = '10.3.200.0/29'

@description('Arbitrary name for public IP resource used for the new azure gateway')
param gatewayPublicIPName string = 'azureGatewayIP'

@description('Arbitrary name for the new gateway')
param gatewayName string = 'azureGateway'

@allowed([
  'Basic'
  'Standard'
  'HighPerformance'
])
@description('The Sku of the Gateway. This must be one of Basic, Standard or HighPerformance.')
param gatewaySku string = 'Basic'

@description('Arbitrary name for the new connection between Azure VNet and other network')
param connectionName string = 'Azure2Other'

@description('Shared key (PSK) for IPSec tunnel')
@secure()
param sharedKey string
param location string = resourceGroup().location

var gatewaySubnetRef = resourceId('Microsoft.Network/virtualNetworks/subnets/', virtualNetworkName, 'GatewaySubnet')

resource localGatewayName_resource 'Microsoft.Network/localNetworkGateways@2020-08-01' = {
  name: localGatewayName
  location: location
  properties: {
    localNetworkAddressSpace: {
      addressPrefixes: localAddressPrefix
    }
    gatewayIpAddress: localGatewayIpAddress
  }
}

module s2sConnection './modules/connection.bicep' = {
  name: 'connectionModule'
  params: {
    connectionName: 'azure-on-premises-connection'
    sharedKey: sharedKey
    virtualNetworkGatewayNameId: virtualNetworkGateway.outputs.virtualNetworkGatewayId
    localNetworkGatewayNameId: localNetworkGateway.outputs.localNetworkGatewayID
  }
  
}

module localNetworkGateway './modules/localNetworkGateway.bicep' = {
  name: 'localNetworkGatewayModule'
  params: {
    localGatewayName: localGatewayName
    localNetworkCIDR: localAddressPrefix
    LocalNetworkGatewayPIP: localGatewayIpAddress
  }
}

resource virtualNetworkName_resource 'Microsoft.Network/virtualNetworks@2015-06-15' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        azureVNetAddressPrefix
      ]
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: subnetPrefix
        }
      }
      {
        name: 'GatewaySubnet'
        properties: {
          addressPrefix: gatewaySubnetPrefix
        }
      }
    ]
  }
}

resource gatewayPublicIPName_resource 'Microsoft.Network/publicIPAddresses@2015-06-15' = {
  name: gatewayPublicIPName
  location: location
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
}

module virtualNetworkGateway './modules/virtualNetworkGateway.bicep' = {
  name: 'virtualNetworkGatewayModule'
  params:{
    vpnType: vpnType
    gatewaySku: gatewaySku
    gatewayPublicIPName_resourceId: gatewayPublicIPName_resource.id
    gatewaySubnetRef: gatewaySubnetRef
    virtualNetworkGatewayName: virtualNetworkName
    enableBGP: true
  }
  dependsOn: [
    virtualNetworkName_resource
  ]
  
}
