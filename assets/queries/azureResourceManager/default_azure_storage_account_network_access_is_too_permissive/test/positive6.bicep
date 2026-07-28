param supportLogStorageAccountType string

param networkAcls object = {
  defaultAction: 'Allow'
}

var computeLocation = 'comloc'

resource positive6 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  kind: 'Storage'
  location: computeLocation
  name: 'positive6'
  properties: {
    networkAcls: networkAcls
  }
  sku: {
    name: supportLogStorageAccountType
  }
  tags: {}
  dependsOn: []
}
