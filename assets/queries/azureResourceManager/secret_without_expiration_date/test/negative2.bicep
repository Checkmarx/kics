resource keyVault1 'Microsoft.KeyVault/vaults@2016-10-01' = {
  name: 'keyVault1'
  location: resourceGroup().location
  tags: {
    displayName: 'keyVault1'
  }
  properties: {
    enabledForDeployment: true
    enabledForTemplateDeployment: true
    enabledForDiskEncryption: true
    tenantId: 'xx0xxx10-00x0-00x0-0x01-x0x0x01xx100'
    accessPolicies: [
      {
        tenantId: 'xx0xxx10-00x0-00x0-0x01-x0x0x01xx100'
        objectId: 'objectId'
        permissions: {
          keys: ['Get']
          secrets: ['List', 'Get', 'Set']
        }
      }
    ]
    sku: {
      name: 'standard'
      family: 'A'
    }
  }
}

resource keyVault1_keyVaultSecret1 'Microsoft.KeyVault/vaults/secrets@2016-10-01' = {
  parent: keyVault1
  name: 'keyVaultSecret1'
  properties: {
    value: 'secretValue'
    attributes: {
      enabled: true
      nbf: 1585206000
      exp: 1679814000
    }
  }
}
