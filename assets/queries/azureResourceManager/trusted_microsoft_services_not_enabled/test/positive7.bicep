resource storage 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: 'positive7'
  location: 'location1'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  kind: 'StorageV2'
  properties: {
    networkAcls: {}
  }
}
