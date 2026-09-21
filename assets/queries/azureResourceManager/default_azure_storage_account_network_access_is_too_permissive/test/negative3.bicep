param supportLogStorageAccountType string

param networkAcls object = {
  defaultAction: 'Deny'
}

var computeLocation = 'comloc'

resource negative3 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  kind: 'Storage'
  location: computeLocation
  name: 'negative3'
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
