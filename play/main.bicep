targetScope = 'subscription'

@description('The prefix to use on resources inside this template')
@minLength(1)
@maxLength(20)
param Prefix string = 'AVS'

@description('Optional: The location the private cloud should be deployed to, by default this will be the location of the deployment')
param Location string = deployment().location

@description('The address space used for the AVS Private Cloud management networks. Must be a non-overlapping /22')
param PrivateCloudAddressSpace string
@description('The SKU that should be used for the first cluster, ensure you have quota for the given SKU before deploying')
@allowed([
  'AV36'
  'AV36T'
])
param PrivateCloudSKU string = 'AV36'
@description('The number of nodes to be deployed in the first/default cluster, ensure you have quota before deploying')
param PrivateCloudHostCount int = 3

@description('Set this to true if you are redeploying, and the VNet already exists')
param VNetExists bool = false
@description('The address space used for the VNet attached to AVS. Must be non-overlapping with existing networks')
param VNetAddressSpace string
@description('The subnet CIDR used for the Gateway Subnet. Must be a /24 or greater within the VNetAddressSpace')
param VNetGatewaySubnet string

@description('Email addresses to be added to the alerting action group. Use the format ["name1@domain.com","name2@domain.com"].')
param AlertEmails array = []
@description('Should a Jumpbox & Bastion be deployed to access the Private Cloud')

param DeployJumpbox bool = false
@description('Username for the Jumpbox VM')
param JumpboxUsername string = 'avsjump'
@secure()
@description('Password for the Jumpbox VM, can be changed later')
param JumpboxPassword string = ''
@description('The subnet CIDR used for the Jumpbox VM Subnet. Must be a /26 or greater within the VNetAddressSpace')
param JumpboxSubnet string = ''
@description('The sku to use for the Jumpbox VM, must have quota for this within the target region')
param JumpboxSku string = 'Standard_D2s_v3'
@description('The subnet CIDR used for the Bastion Subnet. Must be a /26 or greater within the VNetAddressSpace')
param BastionSubnet string = ''

@description('Should HCX be deployed as part of the deployment')
param DeployHCX bool = false
@description('Should SRM be deployed as part of the deployment')
param DeploySRM bool = false
@description('License key to be used if SRM is deployed')
param SRMLicenseKey string = ''
@minValue(1)
@maxValue(10)
@description('Number of vSphere Replication Servers to be created if SRM is deployed')
param VRServerCount int = 1

@description('Opt-out of deployment telemetry')
param TelemetryOptOut bool = false

var deploymentPrefix = 'AVS-${uniqueString(deployment().name, Location)}'

module Networking 'Modules/Networking.bicep' = {
  name: '${deploymentPrefix}-Network'
  params: {
    Prefix: Prefix
    Location: Location
    VNetExists: VNetExists
    VNetAddressSpace: VNetAddressSpace
    VNetGatewaySubnet: VNetGatewaySubnet
  }
}

module Jumpbox 'Modules/JumpBox.bicep' = if (DeployJumpbox) {
  name: '${deploymentPrefix}-Jumpbox'
  params: {
    Prefix: Prefix
    Location: Location
    Username: JumpboxUsername
    Password: JumpboxPassword
    VNetName: Networking.outputs.VNetName
    VNetResourceGroup: Networking.outputs.NetworkResourceGroup
    BastionSubnet: BastionSubnet
    JumpboxSubnet: JumpboxSubnet
    JumpboxSku: JumpboxSku
  }
}

