resource default_Microsoft_Insights 'Microsoft.Storage/storageAccounts/queueServices/providers/diagnosticsettings@2017-05-01-preview' = {
  name: 'Microsoft.Storage/storageAccounts/queueServices/providers'
  properties: {
    logs: [
      {
        category: 'StorageRead'
        enabled: false
      }
      {
        category: 'StorageWrite'
        enabled: true
      }
      {
        category: 'StorageDelete'
        enabled: false
      }
    ]
  }
}
