param supportLogStorageAccountType string

param networkAcls object = {
  defaultAction: 'Allow'
}

var computeLocation = 'comloc'

resource negative6 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  kind: 'Storage'
  location: computeLocation
  name: 'negative6'
  properties: {
    publicNetworkAccess: 'Disabled'
    networkAcls: networkAcls
  }
  sku: {
    name: supportLogStorageAccountType
  }
  tags: {}
  dependsOn: []
}
