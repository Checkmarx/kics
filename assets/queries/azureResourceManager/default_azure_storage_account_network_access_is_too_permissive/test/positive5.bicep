param supportLogStorageAccountType string
param storageApiVersion string = '2021-06-01'

param publicNetworkAccess string = 'Enabled'

var computeLocation = 'comloc'

resource positive5 'Microsoft.Storage/storageAccounts@storageApiVersion' = {
  kind: 'Storage'
  location: computeLocation
  name: 'positive5'
  properties: {
    publicNetworkAccess: publicNetworkAccess
  }
  sku: {
    name: supportLogStorageAccountType
  }
  tags: {}
  dependsOn: []
}
