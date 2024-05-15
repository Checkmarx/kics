@description('Name of the virtual network to use for cloud shell containers.')
param existingVNETName string

@description('Name of the subnet to use for storage account.')
param existingStorageSubnetName string

@description('Name of the subnet to use for cloud shell containers.')
param existingContainerSubnetName string

@description('Name of the storage account in subnet.')
param storageAccountName string

@description('Location for all resources.')
param location string = resourceGroup().location

var containerSubnetRef = resourceId(
  'Microsoft.Network/virtualNetworks/subnets',
  existingVNETName,
  existingContainerSubnetName
)
var storageSubnetRef = resourceId(
  'Microsoft.Network/virtualNetworks/subnets',
  existingVNETName,
  existingStorageSubnetName
)

resource storageAccount 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  kind: 'StorageV2'
  properties: {
    networkAcls: {
      bypass: 'None'
      virtualNetworkRules: [
        {
          id: containerSubnetRef
          action: 'Allow'
        }
        {
          id: storageSubnetRef
          action: 'Allow'
        }
      ]
      defaultAction: 'Deny'
    }
    supportsHttpsTrafficOnly: true
    encryption: {
      services: {
        file: {
          keyType: 'Account'
          enabled: true
        }
        blob: {
          keyType: 'Account'
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
    accessTier: 'Cool'
  }
}

resource storageAccountName_default 'Microsoft.Storage/storageAccounts/blobServices@2019-06-01' = {
  parent: storageAccount
  name: 'default'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  properties: {
    deleteRetentionPolicy: {
      enabled: false
    }
  }
}

resource storageAccountName_default_container 'Microsoft.Storage/storageAccounts/blobServices/containers@2019-06-01' = {
  parent: storageAccountName_default
  name: 'container'
  properties: {
    denyEncryptionScopeOverride: true
    publicAccess: 'None'
    metadata: {}
  }
}
