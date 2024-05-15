resource securitygroup 'Microsoft.Network/networkSecurityGroups@2020-11-01' = {
  name: 'securitygroup'
  location: 'location1'
  tags: {}
  properties: {}
}

resource securitygroup_sr 'Microsoft.Network/networkSecurityGroups/securityRules@2020-11-01' = {
  parent: securitygroup
  properties: {
    description: 'access'
    protocol: 'Tcp'
    sourcePortRange: '*'
    destinationPortRanges: ['6634']
    sourceAddressPrefix: '*'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 100
    direction: 'Inbound'
  }
  name: 'sr'
}
