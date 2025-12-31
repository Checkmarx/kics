resource meuAppService 'Microsoft.Web/sites@2022-09-01' = {
  name: 'meuAppService'
  location: 'West Europe'
  properties: {}
}

resource meuAppService_web 'Microsoft.Web/sites/config@2022-09-01' = {
  parent: meuAppService
  name: 'web'
  properties: {}
}
