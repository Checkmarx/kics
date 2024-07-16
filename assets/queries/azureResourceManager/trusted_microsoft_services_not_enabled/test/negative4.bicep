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
      bypass: 'AzureServices'
      virtualNetworkRules: [
        {
          id: 'id'
          action: 'Allow'
        }
        {
          id: 'id'
          action: 'Allow'
        }
      ]
      defaultAction: 'Deny'
    }
  }
}
