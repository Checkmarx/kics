resource securitygroup 'Microsoft.Network/networkSecurityGroups@2020-11-01' = {
  name: 'securitygroup'
  location: 'location1'
  tags: {}
  properties: {}
}

resource securitygroup_sr 'Microsoft.Network/networkSecurityGroups/securityRules@2020-11-01' = {
  parent: securitygroup
  properties: {
    description: 'access to RDP'
    protocol: 'Tcp'
    sourcePortRange: '*'
    destinationPortRanges: ['3333-3389']
    sourceAddressPrefix: '*'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 100
    direction: 'Inbound'
  }
  name: 'sr'
}
