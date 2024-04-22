param supportLogStorageAccountType string

var computeLocation = 'comloc'

resource positive2 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  kind: 'Storage'
  location: computeLocation
  name: 'positive2'
  properties: {}
  sku: {
    name: supportLogStorageAccountType
  }
  tags: {}
  dependsOn: []
}
