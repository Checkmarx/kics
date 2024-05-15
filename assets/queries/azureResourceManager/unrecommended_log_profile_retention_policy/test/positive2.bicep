resource string 'microsoft.insights/logprofiles@2016-03-01' = {
  name: 'string'
  location: 'location'
  tags: {}
  properties: {
    storageAccountId: 'storageAccountId'
    serviceBusRuleId: 'serviceBusRuleId'
    locations: ['location1']
    categories: ['Write']
    retentionPolicy: {
      enabled: false
      days: 300
    }
  }
}
