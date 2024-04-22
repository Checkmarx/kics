param supportLogStorageAccountType string

var computeLocation = 'comloc'

resource negative1 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  kind: 'Storage'
  location: computeLocation
  name: 'negative1'
  properties: {
    publicNetworkAccess: 'Disabled'
  }
  sku: {
    name: supportLogStorageAccountType
  }
  tags: {}
  dependsOn: []
}
