param containerName string //= 'go-app1'
param location string = 'westeurope'
param imageName string = 'linuxserver/nzbget'
param cpuCores int = 1
param memoryInGb int = 1
param dnsName string //= 'gowebapp001fsk'

resource containerGroup 'Microsoft.ContainerInstance/containerGroups@2019-12-01' = {
  name: containerName
  location: location
  properties: {
    containers: [
      {
        name: containerName
        properties: {
          image: imageName
          resources: {
            requests: {
              cpu: cpuCores
              memoryInGB: memoryInGb
            }
          }
          ports: [
            {
              protocol: 'TCP'
              port: 6789
            }
          ]
        }
      }
    ]
    restartPolicy: 'OnFailure'
    osType: 'Linux'
    ipAddress: {
      type: 'Public'
      dnsNameLabel: dnsName
      ports: [
        {
          protocol: 'TCP'
          port: 6789
        }
      ]
    }
  }
}

output containerIpv4Address string = containerGroup.properties.ipAddress.ip
output containerDnsName string = containerGroup.properties.ipAddress.fqdn
output url string = 'http://${containerGroup.properties.ipAddress.fqdn}:${containerGroup.properties.containers[0].properties.ports[0].port}'
