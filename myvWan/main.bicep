@description('Specifies the location for the deployment.')
param location string = 'northeurope'

@description('Specifies the name of the vwan hub.')
param hubname string = 'hub1'

@description('Specifies the Virtual Hub Address Prefix.')
param hubaddressprefix string = '10.10.10.0/24'

@description('Specifies the name of the vpn gateway.')
param hubvpngwname string = 'hub1-vpngw1'

@description('Specifies the name of the expressroute gateway.')
param hubergwname string = 'hub1-ergw1'

@description('Specifies the name of the vpn site.')
param vpnsitename string = 'vwan1-hub1-vpnsite1'

@secure()
@description('Pre-Shared Key used to establish the site to site tunnel between the Virtual Hub and On-Prem VNet')
param psk string //= uniqueString(subscription().id)

@description('Specifices the VPN Sites VPN Device IP Address')
param ipaddress string = '109.255.28.125'

@description('Specifices the VPN Sites VPN Device FQDN')
param fqdn string = 'ingress.fskelly.com'

@description('Specifices the VPN Sites local IP Addresses')
param addressprefix string = '192.168.1.0/24'

@description('Specifices the VNET1 Address Prefix')
param vnetaddressprefix string = '172.16.10.0/24'

@description('Specifices the Subnet1 Address Prefix')
param snet1addressprefix string = '172.16.10.0/26'

@description('Specifices the VNET1 name')
param vnet1name string = 'vnet1'

//@description('Virtual Hub ID')
//param hubid string

//@description('BGP AS-number for the VPN Gateway')
//param asn int

resource virtualWan 'Microsoft.Network/virtualWans@2020-07-01' = {
  name: 'deploy-vwan'
  location: location
  properties: any({
    type: 'Standard'
    disableVpnEncryption: false
    allowBranchToBranchTraffic: true
    allowVnetToVnetTraffic: true
    office365LocalBreakoutCategory: 'Optimize'
  })
}

resource hub 'Microsoft.Network/virtualHubs@2020-06-01' = {
  name: hubname
  location: location
  properties: {
    addressPrefix: hubaddressprefix
    virtualWan: {
      id: virtualWan.id
    }
  }
}

resource hubvpngw 'Microsoft.Network/vpnGateways@2020-06-01' = {
  name: hubvpngwname
  location: location
  properties: {
    virtualHub: {
      //id: hubid
      id: hub.id
    }
    //bgpSettings: {
    //  asn: asn
    //}
  }
}

resource vpnsite 'Microsoft.Network/vpnSites@2021-05-01' = {
  name: vpnsitename
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressprefix
      ]
    }
    //bgpProperties: {
    // asn: remotesiteasn
    //  bgpPeeringAddress: bgppeeringpddress
    //  peerWeight: 0
    //}
    deviceProperties: {
      linkSpeedInMbps: 500
      deviceModel: 'USG'
      deviceVendor: 'Unifi'
    }
    ipAddress: ipaddress
    virtualWan: {
      //id: wanid
      id: virtualWan.id
    }
/*     vpnSiteLinks: [
      {
        name: 'sitelink1'
        properties: {
          fqdn: fqdn
          linkProperties: {
            linkProviderName: 'VirginMedia'
            linkSpeedInMbps: 500
          }
        }
      }
    ] */
  }
}

resource hubvpnconnection 'Microsoft.Network/vpnGateways/vpnConnections@2020-05-01' = {
  name: '${hubvpngwname}-HubToOnPremConnection'
  parent: hubvpngw
  properties: {
    connectionBandwidth: 10
    enableBgp: false
    sharedKey: psk
    remoteVpnSite: {
      id: vpnsite.id
    }
  }
  dependsOn: [
    hubergw
  ]
}

resource vnet1 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: vnet1name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetaddressprefix
      ]
    }
    subnets: [
      {
        name: 'subnet-1'
        properties: {
          addressPrefix: snet1addressprefix
        }
      }
    ]
  }
}

resource vnet1connection 'Microsoft.Network/virtualHubs/hubVirtualNetworkConnections@2021-05-01' = {
  name: 'deploy-vnetconnection'
  parent: hub
  properties: {
    allowHubToRemoteVnetTransit: true
    allowRemoteVnetToUseHubVnetGateways: true
    enableInternetSecurity: false
    remoteVirtualNetwork: {
      id: vnet1.id
    }
/*     routingConfiguration: {
      associatedRouteTable: {
        id: 'string'
      }
      propagatedRouteTables: {
        ids: [
          {
            id: 'string'
          }
        ]
        labels: [
          'string'
        ]
      }
      vnetRoutes: {
        staticRoutes: [
          {
            addressPrefixes: [
              'string'
            ]
            name: 'string'
            nextHopIpAddress: 'string'
          }
        ]
      } 
    } */
  }
  dependsOn: [
    hubvpngw
  ]
}

resource hubergw 'Microsoft.Network/expressRouteGateways@2021-05-01' = {
  name: hubergwname
  location: location
  properties: {
    autoScaleConfiguration: {
      bounds: {
        min: 1
      }
    }
    virtualHub: {
      id: hub.id
    }
  }
}
