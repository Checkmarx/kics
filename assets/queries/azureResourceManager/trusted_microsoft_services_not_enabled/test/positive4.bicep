resource storage 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: 'storage'
  location: 'location1'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
    networkAcls: {
      bypass: 'None'
      defaultAction: 'Deny'
    }
  }
}
