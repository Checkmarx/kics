resource flowlogs_sample 'Microsoft.Network/networkWatchers/flowLogs@2020-11-01' = {
  name: 'flowlogs/sample'
  location: 'location'
  tags: {}
  properties: {
    targetResourceId: 'targetResourceId'
    storageId: 'storageId'
    enabled: true
    retentionPolicy: {
      days: 92
      enabled: true
    }
    format: {
      type: 'JSON'
    }
  }
}
