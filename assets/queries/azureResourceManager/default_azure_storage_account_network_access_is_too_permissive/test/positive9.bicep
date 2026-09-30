param supportLogStorageAccountType string
param storageApiVersion string = '2021-06-01'

param publicNetworkAccess string = 'SecuredByPerimeter'

var computeLocation = 'comloc'

resource positive9 'Microsoft.Storage/storageAccounts@storageApiVersion' = {
  kind: 'Storage'
  location: computeLocation
  name: 'positive9'
  properties: {
    publicNetworkAccess: publicNetworkAccess
  }
  sku: {
    name: supportLogStorageAccountType
  }
  tags: {}
  dependsOn: []
}
