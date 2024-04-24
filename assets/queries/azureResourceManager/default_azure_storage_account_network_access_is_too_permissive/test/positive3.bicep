param supportLogStorageAccountType string
param storageApiVersion string = '2021-06-01'

var computeLocation = 'comloc'

resource positive3 'Microsoft.Storage/storageAccounts@storageApiVersion' = {
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
