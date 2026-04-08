// Test existing resource as parent
param existingStorageAccountName string = 'myexistingaccount'
param containerName string = 'mycontainer'

// Reference existing storage account
resource existingStorageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' existing = {
  name: existingStorageAccountName
}

// Create a file service under the existing storage account (another child service)
resource fileService 'Microsoft.Storage/storageAccounts/fileServices@2023-01-01' = {
  name: 'default'
  parent: existingStorageAccount
}

// Create a blob service under the existing storage account (child)
resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2023-01-01' = {
  name: 'default'
  parent: existingStorageAccount
}

// Create a container under the blob service (grandchild of existing storage account)
resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-01-01' = {
  name: containerName
  parent: blobService
}

// Create another container under the blob service (another grandchild of existing storage account)
resource anotherContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-01-01' = {
  name: 'anothercontainer'
  parent: blobService
}