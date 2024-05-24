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

resource keyVault1_secretid1 'Microsoft.KeyVault/vaults/secrets@2019-09-01' = {
  parent: keyVault1
  name: 'secretid1'
  tags: {}
  properties: {
    value: 'string'
    contentType: 'string'
  }
}
