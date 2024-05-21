resource sample_securitygroup 'Microsoft.Network/networkSecurityGroups/securityRules@2020-11-01' = {
  name: 'sample/securitygroup'
  properties: {
    description: 'access'
    protocol: 'Tcp'
    sourcePortRange: '*'
    destinationPortRanges: ['4030-5100']
    sourceAddressPrefix: '*'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 100
    direction: 'Inbound'
  }
}
