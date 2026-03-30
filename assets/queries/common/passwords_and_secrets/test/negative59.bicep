// "Generic Token" - baee238e-1921-4801-9c3f-79ae1d7b2cbc - "Avoiding references to module outputs in Bicep"  allow-rule-test (also detected as TF resource access)
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
    // negative1:
    validationToken: myModule.outputs.apiToken
  }
}

// Saída do módulo
output clientUrl string = clientModule.outputs.clientUrl
output clientName string = clientModule.outputs.clientName
