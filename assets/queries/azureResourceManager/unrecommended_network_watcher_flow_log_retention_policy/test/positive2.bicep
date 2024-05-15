resource flowlogs_sample 'Microsoft.Network/networkWatchers/FlowLogs@2020-11-01' = {
  name: 'flowlogs/sample'
  location: 'location'
  tags: {}
  properties: {
    targetResourceId: 'targetResourceId'
    storageId: 'storageId'
    enabled: true
    retentionPolicy: {
      days: 2
    }
    format: {
      type: 'JSON'
    }
  }
}
