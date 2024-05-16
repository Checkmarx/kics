resource sample_securitygroup 'Microsoft.Network/networkSecurityGroups/securityRules@2020-11-01' = {
  name: 'sample/securitygroup'
  properties: {
    description: 'access to SSH'
    protocol: 'Tcp'
    sourcePortRange: '*'
    destinationPortRanges: ['22-23']
    sourceAddressPrefix: '*'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 100
    direction: 'Inbound'
  }
}
