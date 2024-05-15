resource server 'Microsoft.DBforMySQL/servers@2017-12-01' = {
  name: 'server'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    version: '5.6'
    createMode: 'GeoRestore'
    sourceServerId: 'id'
  }
  location: 'location'
  tags: {}
}
