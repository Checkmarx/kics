resource myAppService 'Microsoft.Web/sites@2022-09-01' = {
  name: 'myAppService'
  location: 'West Europe'
  properties: {}
}

resource myAppService_web 'Microsoft.Web/sites/config@2022-09-01' = {
  parent: myAppService
  name: 'web'
  properties: {
    minTlsVersion: '1.1'
  }
}
