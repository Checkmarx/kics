resource string 'microsoft.insights/logprofiles@2016-03-01' = {
  name: 'string'
  location: 'eastus'
  tags: {}
  properties: {
    storageAccountId: 'storageAccountId'
    serviceBusRuleId: 'serviceBusRuleId'
    locations: ['eastus']
    categories: ['Writ']
    retentionPolicy: {
      enabled: true
      days: 450
    }
  }
}
