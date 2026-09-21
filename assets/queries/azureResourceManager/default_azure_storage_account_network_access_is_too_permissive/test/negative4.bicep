param supportLogStorageAccountType string

param publicNetworkAccess string = 'Disabled'

var computeLocation = 'comloc'

resource negative4 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  kind: 'Storage'
  location: computeLocation
  name: 'negative4'
  properties: {
    publicNetworkAccess: publicNetworkAccess
  }
  sku: {
    name: supportLogStorageAccountType
  }
  tags: {}
  dependsOn: []
}
