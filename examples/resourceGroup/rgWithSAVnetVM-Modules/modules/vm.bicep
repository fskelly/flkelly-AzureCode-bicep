var defaultLocation = resourceGroup().location
var diskSku = 'Premium_LRS'
var defaultVmName = '${vmPrefix}-${environmentName}'
var defaultVmNicName = '${defaultVmName}-nic'

param resourceTags object = {
  Environment: 'Dev'
  Project: 'Tutorial'
}

@allowed([
  '2016-Datacenter'
  '2016-Datacenter-Server-Core'
  '2016-Datacenter-Server-Core-smalldisk'
  '2019-Datacenter'
  '2019-Datacenter-Server-Core'
  '2019-Datacenter-Server-Core-smalldisk'
])
param vmOS string = '2019-Datacenter'

@metadata({
  description: 'password for the windows VM'
})
@secure()
param localAdminPassword string 

@minLength(1)
@maxLength(9)
param vmPrefix string

param environmentName string = 'dev'

param virtualNetworkID string

resource vmNic 'Microsoft.Network/networkInterfaces@2017-06-01' = {
  name: defaultVmNicName
  location: defaultLocation
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: '${virtualNetworkID}/subnets/defaultSubnet'
          }
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
  }
}

resource vmDataDisk 'Microsoft.Compute/disks@2019-07-01' = {
  name: '${defaultVmName}-vhd'
  location: defaultLocation
  sku: {
      name: diskSku
  }
  properties: {
      diskSizeGB: 32
      creationData: {
          createOption: 'Empty'
      }
  }

}

resource vm 'Microsoft.Compute/virtualMachines@2019-07-01' = {
  name: defaultVmName
  location: defaultLocation
  properties: {
    osProfile: {
      computerName: defaultVmName
      adminUsername: 'localadm'
      adminPassword: localAdminPassword
      windowsConfiguration: {
        provisionVMAgent: true
      }
    }
    hardwareProfile: {
      vmSize: 'Standard_F2s'
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: vmOS
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
      }
      dataDisks: [
        {
          name: '${defaultVmName}-vhd'
          createOption: 'Attach'
          caching: 'ReadOnly'
          lun: 0
          managedDisk: {
            id: vmDataDisk.id
          }
        }
      ]
    }
    networkProfile: {
      networkInterfaces: [
        {
          properties: {
            primary: true
          }
          id: vmNic.id
        }
      ]
    }
  }
}
