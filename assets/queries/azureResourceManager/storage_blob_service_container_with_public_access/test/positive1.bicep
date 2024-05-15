resource blob_container_example 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-02-01' = {
  name: 'blob/container/example'
  properties: {
    denyEncryptionScopeOverride: true
    publicAccess: 'Container'
    metadata: {}
  }
}
