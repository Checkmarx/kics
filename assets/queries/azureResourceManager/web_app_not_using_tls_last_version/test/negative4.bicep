resource myAppService 'Microsoft.Web/sites@2022-09-01' = {
  name: 'myAppService'
  location: 'West Europe'
  properties: {}
}

resource myApppService_web 'Microsoft.Web/sites/config@2022-09-01' = {
  parent: myAppService
  name: 'config'
  properties: {
    minTlsVersion: '1.1'
  }
}
