@description('Specifies the name of the Azure Storage account.')
param storageAccountName string

@description('Specifies the name of the blob container.')
param containerName string = 'logs'

@description(
  'Specifies the location in which the Azure Storage resources should be deployed.'
)
param location string = resourceGroup().location

resource storageAccount 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}

resource storageAccountName_default_container 'Microsoft.Storage/storageAccounts/blobServices/containers@2019-06-01' = {
  name: '${storageAccountName}/default/${containerName}'
  properties: {
    denyEncryptionScopeOverride: true
    publicAccess: 'Blob'
    metadata: {}
  }
  dependsOn: [storageAccount]
}
