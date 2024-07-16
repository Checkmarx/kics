param supportLogStorageAccountType string
param storageApiVersion string = '2021-06-01'

var computeLocation = 'comloc'

resource negative1 'Microsoft.Storage/storageAccounts@storageApiVersion' = {
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
