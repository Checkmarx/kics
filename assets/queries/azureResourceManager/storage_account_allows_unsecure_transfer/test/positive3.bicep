resource storageaccount1Positive3 'Microsoft.Storage/storageAccounts@2018-02-01' = {
  name: 'storageaccount1Positive3'
  tags: {
    displayName: 'storageaccount1'
  }
  location: resourceGroup().location
  kind: 'StorageV2'
  sku: {
    name: 'Premium_LRS'
    tier: 'Premium'
  }
  properties: {}
}
