import { common, tagsObject, deployName, removeSpace } from '../../../CommonValues.bicep'

@description('Nome do sistema')
param systemName string

@description('Nome do recurso')
param resourceName string = removeSpace(systemName)

@description('Enterprise Tagging object')
param tags tagsObject

resource kvTest 'Microsoft.KeyVault/vaults@2023-07-01' existing = {
  name: 'kv-test-sample'
  scope: resourceGroup('rg-test-sample')
}

module consumerModule '../SecretConsumer/Resource.bicep' = {
  name: deployName(resourceName, 'Test.SecretConsumer', tags.lastReleaseId)
  params: {
    systemName: systemName
    resourceName: resourceName
    tags: tags
    apiClientSecret: kvTest.getSecret('secret-sample') 
  }
}
