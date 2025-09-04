param systemName string
param resourceName string
param tags object
param originUrl string

module myModule '../AnotherModule/Resource.bicep' = {
  name: '${resourceName}-MyModule'
  params: {
    systemName: systemName
    resourceName: resourceName
    tags: tags
    apiUrl: originUrl
  }
}

module clientModule '../ClientModule/Resource.bicep' = {
  name: '${resourceName}-ClientModule'
  params: {
    systemName: systemName
    resourceName: resourceName
    tags: tags
    validationToken: myModule.outputs.apiToken 
  }
}

// Saída do módulo
output clientUrl string = clientModule.outputs.clientUrl
output clientName string = clientModule.outputs.clientName
