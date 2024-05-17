resource storageaccount1Positive2 'Microsoft.Storage/storageAccounts@2017-10-01' = {
  name: 'storageaccount1Positive2'
  tags: {
    displayName: 'storageaccount1'
  }
  location: resourceGroup().location
  kind: 'StorageV2'
  sku: {
    name: 'Premium_LRS'
    tier: 'Premium'
  }
}
