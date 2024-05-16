resource sample_firewall 'Microsoft.Sql/servers/firewallRules@2021-02-01-preview' = {
  name: 'sample/firewall'
  properties: {
    endIpAddress: '255.255.255.255'
    startIpAddress: '0.0.0.0/0'
  }
}
