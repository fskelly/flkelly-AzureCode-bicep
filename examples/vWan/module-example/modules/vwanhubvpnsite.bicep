@description('Specifies the name of the VPN Site instance.')
param vwanHubVpnSiteName string //= 'wan1'

@description('Specifies the location for the deployment.')
param vwanHubLocation string //= 'northeurope'

@description('Specifices the VPN Sites local IP Addresses')
param vpnRangeCIDR string //= '192.168.1.0/24'

@description('Specifices the IP Address of the VPN gateway device')
param vpnDeviceIP string //= '1.2.3.4'

@description('Specifies the ID for the Virtual Wan Hub.')
param vwanHubID string //= 'northeurope'

@description('Specifies the tags top be added to the resources.')
param resourceTags object

resource virtualWanHubVpnSite 'Microsoft.Network/vpnSites@2021-05-01' = {
  name: vwanHubVpnSiteName
  location: vwanHubLocation
  tags: resourceTags
  properties: {
    addressSpace: {
      addressPrefixes: [
        vpnRangeCIDR
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
    ipAddress: vpnDeviceIP
    virtualWan: {
      id: vwanHubID
    }
//     vpnSiteLinks: [
//      {
//        name: 'sitelink1'
//        properties: {
//          fqdn: fqdn
//          linkProperties: {
//            linkProviderName: 'VirginMedia'
//            linkSpeedInMbps: 500
//          }
//        }
//      }
//    ] 
   }
} 

output vwanHubVpnSiteID string = virtualWanHubVpnSite.id
