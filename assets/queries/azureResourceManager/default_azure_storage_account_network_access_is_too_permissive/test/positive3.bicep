param supportLogStorageAccountType string

var computeLocation = 'comloc'

resource positive3 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  kind: 'Storage'
  location: computeLocation
  name: 'positive3'
  properties: {
    publicNetworkAccess: 'Enabled'
  }
  sku: {
    name: supportLogStorageAccountType
  }
  tags: {}
  dependsOn: []
}
