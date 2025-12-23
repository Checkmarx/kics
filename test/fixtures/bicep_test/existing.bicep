// Simple Bicep file with existing resources
param existingKeyVaultName string = 'my-keyvault'
param secretName string = 'my-secret'

// Reference existing Key Vault
resource existingKeyVault 'Microsoft.KeyVault/vaults@2022-11-01' existing = {
  name: existingKeyVaultName
}

// Create a new storage account (should NOT be filtered out)
resource newStorageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: 'mystorageaccount'
  location: 'East US'
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}

output keyVaultUri string = existingKeyVault.properties.vaultUri