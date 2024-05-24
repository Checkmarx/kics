resource keyVaultInstance 'Microsoft.KeyVault/vaults@2019-09-01' = {
  name: 'keyVaultInstance'
  location: 'location'
  tags: {}
  properties: {
    tenantId: '72f98888-8666-4144-9199-2d7cd0111111'
    sku: {
      family: 'A'
      name: 'standard'
    }
    accessPolicies: [
      {
        tenantId: '72f98888-8666-4144-9199-2d7cd0111111'
        objectId: '99998888-8666-4144-9199-2d7cd0111111'
        permissions: {
          keys: ['encrypt']
        }
      }
    ]
    vaultUri: 'string'
    enabledForDeployment: true
    enabledForDiskEncryption: true
    enabledForTemplateDeployment: true
    enableSoftDelete: true
    softDeleteRetentionInDays: 80
    enableRbacAuthorization: true
    enablePurgeProtection: false
  }
}
