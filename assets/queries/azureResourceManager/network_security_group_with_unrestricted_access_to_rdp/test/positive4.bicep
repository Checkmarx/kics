resource security_group 'Microsoft.Network/networkSecurityGroups@2020-11-01' = {
  name: 'security group'
  location: 'location1'
  tags: {}
  properties: {
    securityRules: [
      {
        id: 'id'
        properties: {
          description: 'access to RDP'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 301
          direction: 'Inbound'
        }
        name: 'security rule'
      }
    ]
  }
}
