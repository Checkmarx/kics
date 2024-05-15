param supportLogStorageAccountType string
param storageApiVersion string = '2021-06-01'

var computeLocation = 'comloc'

resource positive2 'Microsoft.Storage/storageAccounts@storageApiVersion' = {
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
