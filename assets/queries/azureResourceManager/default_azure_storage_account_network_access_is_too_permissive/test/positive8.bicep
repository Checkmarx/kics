param supportLogStorageAccountType string

param networkAcls object = {
  defaultAction: 'Allow'
}

var computeLocation = 'comloc'

resource positive8 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  kind: 'Storage'
  location: computeLocation
  name: 'positive8'
  properties: {
    publicNetworkAccess: 'SecuredByPerimeter'
    networkAcls: networkAcls
  }
  sku: {
    name: supportLogStorageAccountType
  }
  tags: {}
  dependsOn: []
}
