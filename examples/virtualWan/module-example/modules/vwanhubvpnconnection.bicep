//@description('Specifies the name of the VPN Connection instance.')
//param vwanHubVpnConnectionName string //= 'wan1'

@description('Specifies the name of the van hub gateway.')
param vwanHubGatewayName string //

@secure()
@description('Pre-Shared Key used to establish the site to site tunnel between the Virtual Hub and On-Prem VNet')
param psk string

@description('Specifies the ID of the VPN Site')
param remoteVpnSiteID string

resource vwanHubVpnGateway 'Microsoft.Network/vpnGateways@2020-06-01' existing  = {
  name: vwanHubGatewayName
}

resource virtualWanHubVpnConnection 'Microsoft.Network/vpnGateways/vpnConnections@2020-05-01' = {
  name: '${vwanHubGatewayName}-HubToOnPremConnection'
  parent: vwanHubVpnGateway
  properties: {
    connectionBandwidth: 10
    enableBgp: false
    sharedKey: psk
    remoteVpnSite: {
      id: remoteVpnSiteID
    }
  }
}
