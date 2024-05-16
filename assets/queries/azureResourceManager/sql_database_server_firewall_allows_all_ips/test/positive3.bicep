resource sqlServer1 'Microsoft.Sql/servers@2021-02-01-preview' = {
  name: 'sqlServer1'
  location: resourceGroup().location
  tags: {
    displayName: 'sqlServer1'
  }
  properties: {
    administratorLogin: 'adminUsername'
    administratorLoginPassword: 'adminPassword'
  }
}

resource sqlServer1_AllowAllWindowsAzureIps 'Microsoft.Sql/servers/firewallRules@2021-02-01-preview' = {
  parent: sqlServer1
  location: resourceGroup().location
  name: 'AllowAllWindowsAzureIps'
  properties: {
    endIpAddress: '255.255.255.255'
    startIpAddress: '0.0.0.0'
  }
}
