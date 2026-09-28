// Parameters
@description('The name of the Storage Account, must be between 3 and 24 characters in length and use alphanumeric lower-case letters and numbers only.')
@minLength(3)
@maxLength(24)
param name string

@description('The location where the Storage Account will be deployed.')
param location string

@description('The performance and replication configuration of the Storage Account.')
param sku object

@description('Resource ID of the subnet within the virtual network for private access to the Storage Account.')
param vnetSubnetId string

@description('Resource ID of the subnet within the virtual network for private access to the Storage Account.')
param privateSubnetId string

@description('Resource ID of the subnet within the virtual network for public access to the Storage Account.')
param publicSubnetId string

param agentsVirtualNetworkSubnetId string = '/subscriptions/69dfc25b-32a0-4f72-94ee-89ecd603700b/resourceGroups/rg-mdp-prod-shared-win-legacy-weu/providers/Microsoft.Network/virtualNetworks/vnet-prod-mdp-shared-win-legacy-weu/subnets/MdpSubnet'

@description('The Access list of Vnet which can access the Storage account. This is needed for enabling access from Databricks to Storage account')
param networkAcls object = {
  bypass: 'AzureServices,Logging,Metrics'
  virtualNetworkRules: [
    {
      id: vnetSubnetId
      action: 'Allow'
    }
    {
      id: privateSubnetId
      action: 'Allow'
    }
    {
      id: publicSubnetId
      action: 'Allow'
    }
    {
      id: agentsVirtualNetworkSubnetId
      action: 'Allow'
      state: 'Succeeded'
    }
  ]
  ipRules: [
    {
      value: '193.173.45.0/25' // VDI OVD IP
      action: 'Allow'
    }
    {
      value: '37.74.18.112' // FUSE IP #1
      action: 'Allow'
    }
    {
      value: '37.74.18.114' // FUSE IP #2
      action: 'Allow'
    }
  ]
  defaultAction: 'Deny'
}

@description('Trusted access-enabled resource types for Blob service.')
param trustedAccessEnabledResourceTypes array = [
  'Microsoft.Databricks/accessConnectors'
]

// Resource Definition
@description('Creates a Storage Account with specified SKU, security settings, and network configurations.')
resource storageAccount 'Microsoft.Storage/storageAccounts@2025-06-01' = {
  name: name
  location: location
  sku: sku
  kind: 'StorageV2'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    defaultToOAuthAuthentication: false
    minimumTlsVersion: 'TLS1_2'
    allowSharedKeyAccess: true
    allowBlobPublicAccess: false
    allowCrossTenantReplication: false
    publicNetworkAccess: 'Enabled'
    customDomain: null
    networkAcls: networkAcls
    isHnsEnabled: true
    isSftpEnabled: false
    accessTier: 'Hot'
    supportsHttpsTrafficOnly: true
    encryption: {
      keySource: 'Microsoft.Storage'
      services: {
        file: {
          enabled: true
        }
        blob: {
          enabled: true
        }
        table: {
          enabled: true
        }
        queue: {
          enabled: true
        }
      }
    }
  }
}

resource defenderForStorageSettings 'Microsoft.Security/DefenderForStorageSettings@2022-12-01-preview' = {
  name: 'current'
  scope: storageAccount
  properties: {
    isEnabled: true
    malwareScanning: {
      onUpload: {
        isEnabled: false
      }
    }
    sensitiveDataDiscovery: {
      isEnabled: false
    }
    overrideSubscriptionLevelSettings: true
  }
}

resource default 'Microsoft.Storage/storageAccounts/blobServices@2024-01-01' = {
  parent: storageAccount
  name: 'default'
  properties: {
    deleteRetentionPolicy: {
      enabled: true
      days: 30
    }
    containerDeleteRetentionPolicy: {
      enabled: true
      days: 30
    }
    trustedAccessEnabledResourceTypes: trustedAccessEnabledResourceTypes
  }
}

resource defaultContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2019-06-01' = {
  parent: default
  name: 'default'
  properties: {
    publicAccess: 'None'
  }
}

resource monitoringContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-09-01' = {
  parent: default
  name: 'monitoring-unity'
  properties: {
    publicAccess: 'None'
  }
}

resource checkpointsContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-09-01' = {
  parent: default
  name: 'checkpoints'
  properties: {
    publicAccess: 'None'
  }
}

resource logsContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-09-01' = {
  parent: default
  name: 'logs'
  properties: {
    publicAccess: 'None'
  }
}

resource landingContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-09-01' = {
  parent: default
  name: 'landing'
  properties: {
    publicAccess: 'None'
  }
}


// Outputs
var accountName = storageAccount.name
var endpointSuffix = environment().suffixes.storage
var key = storageAccount.listKeys().keys[0].value

output id string = storageAccount.id
output name string = storageAccount.name
output storageAccountConnectionString string = 'DefaultEndpointsProtocol=https;AccountName=${accountName};EndpointSuffix=${endpointSuffix};AccountKey=${key}'
