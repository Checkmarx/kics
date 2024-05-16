resource storageaccount1Positive3 'Microsoft.Storage/storageAccounts@2016-12-01' = {
  name: 'storageaccount1Positive3'
  tags: {
    displayName: 'storageaccount1'
  }
  location: resourceGroup().location
  kind: 'Storage'
  sku: {
    name: 'Premium_LRS'
    tier: 'Premium'
  }
  properties: {}
}
