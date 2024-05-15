resource sample_firewall 'Microsoft.Sql/servers/firewallRules@2021-02-01-preview' = {
  name: 'sample/firewall'
  properties: {
    endIpAddress: '192.168.1.2'
    startIpAddress: '192.168.1.254'
  }
}
