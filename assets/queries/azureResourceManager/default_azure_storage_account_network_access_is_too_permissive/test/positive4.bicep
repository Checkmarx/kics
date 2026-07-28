param supportLogStorageAccountType string

param networkAcls object = {
  defaultAction: 'Allow'
}

var computeLocation = 'comloc'

resource positive4 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  kind: 'Storage'
  location: computeLocation
  name: 'positive4'
  properties: {
    publicNetworkAccess: 'Enabled'
    networkAcls: networkAcls
  }
  sku: {
    name: supportLogStorageAccountType
  }
  tags: {}
  dependsOn: []
}
