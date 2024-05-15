resource sample_securitygroup 'Microsoft.Network/networkSecurityGroups/securityRules@2020-11-01' = {
  name: 'sample/securitygroup'
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
}
