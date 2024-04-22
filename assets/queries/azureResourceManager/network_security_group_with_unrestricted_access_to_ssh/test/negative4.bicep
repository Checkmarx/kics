resource security_group 'Microsoft.Network/networkSecurityGroups@2020-11-01' = {
  name: 'security group'
  location: 'location1'
  tags: {}
  properties: {
    securityRules: [
      {
        id: 'id'
        properties: {
          description: 'access to SSH'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '22'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Deny'
          priority: 301
          direction: 'Inbound'
        }
        name: 'security rule'
      }
    ]
  }
}
