param vmSku string = 'Standard_A1_v2'

@allowed([
  '16.04-LTS'
  '18.04-LTS'
  '18.10'
  '19.04'
])
param ubuntuOSVersion string = '18.04-LTS'

@maxLength(61)
param vmssName string

@minValue(1)
@maxValue(100)
param instanceCount int

param adminUsername string

@secure()
param adminPassword string

param networkSecurityGroupName string = '${vmssName}-nsg'

param location string = resourceGroup().location

var namingInfix = toLower(substring('${vmssName}${uniqueString(resourceGroup().id)}', 0, 9))
var longNamingInfix = toLower(vmssName)
var addressPrefix = '10.0.0.0/16'
var subnetPrefix = '10.0.0.0/24'
var virtualNetworkName = '${namingInfix}vnet'
var publicIPAddressName = '${namingInfix}pip'
var subnetName = '${namingInfix}subnet'
var loadBalancerName = '${namingInfix}lb'
var natPoolName = '${namingInfix}natpool'
var bePoolName = '${namingInfix}bepool'
var natStartPort = 50000
var natEndPort = 50119
var natBackendPort = 3389
var nicname = '${namingInfix}nic'
var ipConfigName = '${namingInfix}ipconfig'
var osType = {
  publisher: 'Canonical'
  offer: 'UbuntuServer'
  sku: ubuntuOSVersion
  version: 'latest'
}
var imageReference = osType

module vnet './vnet.bicep' = {
  name: 'vnetDeploy'
  params: {
    virtualNetworkName: virtualNetworkName
    vnetLocation: location
    addressPrefix: addressPrefix
    subnetName: subnetName
    subnetPrefix: subnetPrefix
    nsgID: nsg.outputs.nsgID
  }
  
}

/* resource virtualNetwork 'Microsoft.Network/virtualnetworks@2015-05-01-preview' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: subnetPrefix
        }
      }
    ]
  }
} */

module publicIP './pip.bicep' = {
  name: 'publicIpDeploy'
  params: {
    longNamingInfix: longNamingInfix
    publicIPAddressLocation: location
    publicIPAddressName: publicIPAddressName
  }
  
}

/* resource publicIP 'Microsoft.Network/publicIPAddresses@2020-06-01' = {
  name: publicIPAddressName
  location: location
  properties: {
    publicIPAllocationMethod: 'Dynamic'
    dnsSettings: {
      domainNameLabel: longNamingInfix
    }
  }
} */

module loadBalancer './loadBalancer.bicep' = {
  name: 'loadBalancerDeploy'
  params: {
    loadBalancerLocation: location
    loadBalancerName: loadBalancerName
    bePoolName: bePoolName
    natStartPort: natStartPort
    natEndPort: natEndPort
    natBackendPort: natBackendPort
    natPoolName: natPoolName
    publicIPId: publicIP.outputs.pipID
  }
  
}

/* resource loadBalancer 'Microsoft.Network/loadBalancers@2020-06-01' = {
  name: loadBalancerName
  location: location
  properties: {
    frontendIPConfigurations: [
      {
        name: 'LoadBalancerFrontEnd'
        properties: {
          publicIPAddress: {
            id: publicIP.id
          }
        }
      }
    ]
    backendAddressPools: [
      {
        name: bePoolName
      }
    ]
    inboundNatPools: [
      {
        name: natPoolName
        properties: {
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', loadBalancerName, 'loadBalancerFrontEnd')
          }
          protocol: 'Tcp'
          frontendPortRangeStart: natStartPort
          frontendPortRangeEnd: natEndPort
          backendPort: natBackendPort
        }
      }
    ]
  }
} */

module vmss './vmss.bicep' = {
  name: 'vmssDeploy'
  params: {
    adminUsername: adminUsername
    adminPassword: adminPassword
    bePoolName: loadBalancer.outputs.bePoolName
    natPoolName: loadBalancer.outputs.natPoolName
    imageReference: imageReference
    instanceCount: instanceCount
    ipConfigName: ipConfigName
    nicname: nicname
    loadBlancerID: loadBalancer.outputs.loadBalancerID
    namingInfix: namingInfix
    subnetName: vnet.outputs.subnetName
    vmSku: vmSku
    vmssLocation: location
    vmssName: vmssName
    vnetID: vnet.outputs.vnetID
  }
}

/* resource vmss 'Microsoft.Compute/virtualMachineScaleSets@2020-06-01' = {
  name: vmssName
  location: location
  sku: {
    name: vmSku
    tier: 'Standard'
    capacity: instanceCount
  }
  properties: {
    overprovision: true
    upgradePolicy: {
      mode: 'Manual'
    }
    virtualMachineProfile: {
      storageProfile: {
        osDisk: {
          createOption: 'FromImage'
          caching: 'ReadWrite'
        }
        imageReference: imageReference
      }
      osProfile: {
        computerNamePrefix: namingInfix
        adminUsername: adminUsername
        adminPassword: adminPassword
      }
      networkProfile: {
        networkInterfaceConfigurations: [
          {
            name: nicname
            properties: {
              primary: true
              ipConfigurations: [
                {
                  name: ipConfigName
                  properties: {
                    subnet: {
                      id: '${vnet.outputs.vnetID}/subnets/${subnetName}'
                    }
                    loadBalancerBackendAddressPools: [
                      {
                        id: '${loadBalancer.outputs.loadBalancerID}/backendAddressPools/${bePoolName}'
                      }
                    ]
                    loadBalancerInboundNatPools: [
                      {
                        id: '${loadBalancer.outputs.loadBalancerID}/inboundNatPools/${natPoolName}'
                      }
                    ]
                  }
                }
              ]
            }
          }
        ]
      }
    }
  }
}
 */

module nsg './nsg.bicep' = {
  name: 'nsgDeploy'
  params: {
    startPort: natStartPort
    endPort: natEndPort
    networkSecurityGroupLocation: location
    networkSecurityGroupName: networkSecurityGroupName
    natBackendPort: natBackendPort
  }
}

resource autoScaleSettings 'microsoft.insights/autoscalesettings@2015-04-01' = {
  name: 'cpuautoscale'
  location: location
  properties: {
    name: 'cpuautoscale'
    targetResourceUri: vmss.outputs.vmssID
    enabled: true
    profiles: [
      {
        name: 'Profile1'
        capacity: {
          minimum: '1'
          maximum: '10'
          default: '1'
        }
        rules: [
          {
            metricTrigger: {
              metricName: 'Percentage CPU'
              metricNamespace: ''
              metricResourceUri: vmss.outputs.vmssID
              timeGrain: 'PT1M'
              timeWindow: 'PT5M'
              timeAggregation: 'Average'
              operator: 'GreaterThan'
              threshold: 50
              statistic: 'Average'
            }
            scaleAction: {
              direction: 'Increase'
              type: 'ChangeCount'
              value: '1'
              cooldown: 'PT5M'
            }
          }
          {
            metricTrigger: {
              metricName: 'Percentage CPU'
              metricNamespace: ''
              metricResourceUri: vmss.outputs.vmssID
              timeGrain: 'PT1M'
              timeWindow: 'PT5M'
              timeAggregation: 'Average'
              operator: 'LessThan'
              threshold: 30
              statistic: 'Average'
            }
            scaleAction: {
              direction: 'Decrease'
              type: 'ChangeCount'
              value: '1'
              cooldown: 'PT5M'
            }
          }
        ]
      }
    ]
  }
}
