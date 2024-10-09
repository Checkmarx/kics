param supportLogStorageAccountType string
param storageApiVersion string = '2021-06-01'

var computeLocation = 'comloc'

resource positive1 'Microsoft.Storage/storageAccounts@storageApiVersion' = {
  kind: 'Storage'
  location: computeLocation
  name: 'positive1'
  properties: {
    networkAcls: {
      defaultAction: 'Allow'
    }
  }
  sku: {
    name: supportLogStorageAccountType
  }
  tags: {}
  dependsOn: []
}
