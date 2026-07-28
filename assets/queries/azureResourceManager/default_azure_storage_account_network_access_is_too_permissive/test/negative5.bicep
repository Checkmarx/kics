param supportLogStorageAccountType string

param networkAcls object = {
  defaultAction: 'Deny'
}

var computeLocation = 'comloc'

resource negative5 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  kind: 'Storage'
  location: computeLocation
  name: 'negative5'
  properties: {
    networkAcls: networkAcls
  }
  sku: {
    name: supportLogStorageAccountType
  }
  tags: {}
  dependsOn: []
}
