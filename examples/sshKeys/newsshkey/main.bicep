param location string = 'northeurope'
param sshKeyName string = 'sshkeys02'

resource key1 'Microsoft.Compute/sshPublicKeys@2021-11-01' = {
  name: sshKeyName
  location: location
  tags: {
    Use: 'Testing'
    CanBeDeleted: 'yes'
  }
  properties: {
    publicKey: 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDhpSjWCGPqT4+znLcYttBh3ixWpkBTKbkwKEeIQD9bPWa5YX/q95i9hn2JrVD88qzAL5z53tK62AYcKkow0L2PtLQ7GSnWbRhxq8PLazwnqiID6B8stMIcKBaTOl36GPq4stv17K59rHwmjcDkKj2s1/MsqRZ33/ObLDT40TSrGz1MAB+C5F/+7vW/3dXfrWc5eMoq24G+xHQ6mHsM+mYB1ogbtxj7R5ihg+HzEBZaYAp1LL17/YyLoJOor5vuzCtmT44HGJ0YMoX2aFMvUJeuwyuroxohIdMzcFNjRD8BXi46RjeBOVVbxftkqJya+QVLq9roaZDIbbNGDNrgrTeN testing1'
  }
}

output name string = key1.name
output name string = key1.properties.privateKey
