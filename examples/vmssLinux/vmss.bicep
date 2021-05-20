param vmssName string
param vmssLocation string
param vmSku string
param instanceCount int
param imageReference object
param namingInfix string
param adminUsername string
param nicname string
param ipConfigName string
param loadBlancerID string
param vnetID string
param subnetName string
param bePoolName string
param natPoolName string
//param nsgID string

@secure()
param adminPassword string

resource vmss 'Microsoft.Compute/virtualMachineScaleSets@2020-06-01' = {
  name: vmssName
  location: vmssLocation
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
                      id: '${vnetID}/subnets/${subnetName}'
                    }
                    loadBalancerBackendAddressPools: [
                      {
                        id: '${loadBlancerID}/backendAddressPools/${bePoolName}'
                      }
                    ]
                    loadBalancerInboundNatPools: [
                      {
                        id: '${loadBlancerID}/inboundNatPools/${natPoolName}'
                      }
                    ]
                  }
                }
              ]
              //networkSecurityGroup: {
              //  id: nsgID
              //}
            }
          }
        ]
      }
    }
  }
}

output vmssID string = vmss.id
