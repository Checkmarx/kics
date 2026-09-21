param supportLogStorageAccountType string
param storageApiVersion string = '2021-06-01'

var computeLocation = 'comloc'

resource positive7 'Microsoft.Storage/storageAccounts@storageApiVersion' = {
  kind: 'Storage'
  location: computeLocation
  name: 'positive7'
  properties: {
    publicNetworkAccess: 'SecuredByPerimeter'
  }
  sku: {
    name: supportLogStorageAccountType
  }
  tags: {}
  dependsOn: []
}
