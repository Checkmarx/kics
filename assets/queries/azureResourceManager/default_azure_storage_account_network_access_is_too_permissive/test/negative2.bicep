param supportLogStorageAccountType string

var computeLocation = 'comloc'

resource negative2 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  kind: 'Storage'
  location: computeLocation
  name: 'negative2'
  properties: {
    networkAcls: {
      defaultAction: 'Deny'
    }
  }
  sku: {
    name: supportLogStorageAccountType
  }
  tags: {}
  dependsOn: []
}
