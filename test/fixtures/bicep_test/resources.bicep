@description(
  'Username for the Virtual Machine.'
)
param adminUsername string

@description('Password for the Virtual Machine.')
@minLength(12)
@secure()
param adminPassword string

@description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource.')
@allowed([
  'allLogs'
  'ConnectedClientList'
])
param diagnosticLogCategoriesToEnable array = [
  'allLogs'
]

@description(
  '''The Windows version for the VM.
 This will pick a fully patched image of this given Windows version.'''
)
@allowed(
  [
    '2008-R2-SP1'
    '2012-Datacenter'
    '2012-R2-Datacenter'
    '2016-Nano-Server'
    '2016-Datacenter-with-Containers'
    '2016-Datacenter'
    '2019-Datacenter'
    '2019-Datacenter-Core'
    '2019-Datacenter-Core-smalldisk'
    '2019-Datacenter-Core-with-Containers'
    '2019-Datacenter-Core-with-Containers-smalldisk'
    '2019-Datacenter-smalldisk'
    '2019-Datacenter-with-Containers'
    '2019-Datacenter-with-Containers-smalldisk'
  ]
)
param OSVersion string = '2019-Datacenter'

@description('Optional. Tags of the resource.')
param tags object = {}

@minValue(1)
@description('Optional. The number of replicas to be created per primary.')
param replicasPerPrimary int = 1

@minValue(1)
@description('Optional. The number of shards to be created on a Premium Cluster Cache.')
param shardCount int = 1

@allowed([
  0
  1
  2
  3
  4
  5
  6
])
@description('Optional. The size of the Redis cache to deploy. Valid values: for C (Basic/Standard) family (0, 1, 2, 3, 4, 5, 6), for P (Premium) family (1, 2, 3, 4).')
param capacity int = 2

@description('The name of an existing keyvault, that it will be used to store secrets (connection string)' )
param keyvaultName string

@allowed([
  'Basic'
  'Premium'
  'Standard'
])
@description('Optional, default is Standard. The type of Redis cache to deploy.')
param skuName string = 'Standard'

@description('Optional. The full resource ID of a subnet in a virtual network to deploy the Redis cache in. Example format: /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/Microsoft.{Network|ClassicNetwork}/VirtualNetworks/vnet1/subnets/subnet1.')
param subnetId string = ''

@description('Optional. The name of the diagnostic setting, if deployed.')
param diagnosticSettingsName string = '${name}-diagnosticSettings'

@description('Optional. Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
param diagnosticWorkspaceId string = ''

@description('Optional. The name of metrics that will be streamed.')
@allowed([
  'AllMetrics'
])
param diagnosticMetricsToEnable array = [
  'AllMetrics'
]

@description('Has the resource private endpoint?')
param hasPrivateLink bool = false

@description('Optional. Specifies whether the non-ssl Redis server port (6379) is enabled.')
param enableNonSslPort bool = false

@description('Optional. All Redis Settings. Few possible keys: rdb-backup-enabled,rdb-storage-connection-string,rdb-backup-frequency,maxmemory-delta,maxmemory-policy,notify-keyspace-events,maxmemory-samples,slowlog-log-slower-than,slowlog-max-len,list-max-ziplist-entries,list-max-ziplist-value,hash-max-ziplist-entries,hash-max-ziplist-value,set-max-intset-entries,zset-max-ziplist-entries,zset-max-ziplist-value etc.')
param redisConfiguration object = {}

@minValue(1)
@description('Optional. The number of replicas to be created per primary.')
param replicasPerMaster int = 1

@description('Size of the virtual machine.')
param vmSize string = 'Standard_D2_v3'

@description('Location for all resources.')
param location string = resourceGroup().location

@description('Name of the virtual machine.')
param vmName string = 'simple-vm'

param parenthesis string = ('simple-vm')

@description('Name of the virtual network to use for cloud shell containers.')
param existingVNETName string

@description('Name of the subnet to use for storage account.')
param existingStorageSubnetName string

@description('Name of the subnet to use for cloud shell containers.')
param existingContainerSubnetName string

@description('Required. The name of the Redis cache resource. Start and end with alphanumeric. Consecutive hyphens not allowed')
@maxLength(63)
@minLength(1)
param name string

param arrayP array = [
  'allLogs'
  'ConnectedClientList'
]

var storageAccountName = 'bootdiags${uniqueString(resourceGroup().id)}'

var nicName = 'myVMNic'

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

var diagnosticsLogsSpecified = [for category in filter(diagnosticLogCategoriesToEnable, item => item != 'allLogs'): {
  category: category
  enabled: true
}]

var diagnosticsLogs = contains(diagnosticLogCategoriesToEnable, 'allLogs') ? [
  {
    categoryGroup: 'allLogs'
    enabled: true
  }
] : diagnosticsLogsSpecified

var diagnosticsMetrics = [for metric in diagnosticMetricsToEnable: {
  category: metric
  timeGrain: null
  enabled: true
}]

@sys.description('This is a test description for resources')
resource vm 'Microsoft.Compute/virtualMachines@2021-03-01' = {
  name: vmName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: 'computer'
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: OSVersion
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
        }
      }
      dataDisks: [
        {
          diskSizeGB: 1023
          lun: 0
          createOption: 'Empty'
        }
      ]
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: resourceId('Microsoft.Network/networkInterfaces', 'nick')
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
        storageUri: reference(
          resourceId('Microsoft.Storage/storageAccounts', storageAccountName)
        ).primaryEndpoints.blob
      }
    }
  }
  dependsOn: [
    resourceId('Microsoft.Network/networkInterfaces', nicName)
    resourceId('Microsoft.Storage/storageAccounts', storageAccountName)
  ]
}

resource nic 'Microsoft.Network/networkInterfaces@2021-03-01' = {
  name: arrayP[0]
  location: [
    for i in name: {
      name: nicName
    }
  ]
  userAssignedIdentities: {
    '${resourceId('Microsoft.ManagedIdentity/userAssignedIdentities',nicName)}': {}
  }
  assignableScopes: [subscription().id]
}

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
    publicAccess: 'Blob'
    metadata: {}
  }
}

resource redisCache 'Microsoft.Cache/redis@2021-06-01' = {
  name: name
  location: location
  tags: tags
//  identity: identity    //20230301-getting a strange error that publcNetworkAccess and Identity cannot be set at the same time. The following updates can't be processed in one single request, please send seperate request to update them: 'properties.publicNetworkAccess,identity
  properties: {
    enableNonSslPort: enableNonSslPort
    minimumTlsVersion: '1.2'
    publicNetworkAccess: hasPrivateLink ? 'Disabled' : null
    redisConfiguration: !empty(redisConfiguration) ? redisConfiguration : null
    redisVersion: '6'
    replicasPerMaster: skuName == 'Premium' ? replicasPerMaster : null
    replicasPerPrimary: skuName == 'Premium' ? replicasPerPrimary : null
    shardCount: skuName == 'Premium' ? shardCount : null // Not supported in free tier
    sku: {
      capacity: capacity
      family: skuName == 'Premium' ? 'P' : 'C'
      name: skuName
    }
    subnetId: !empty(subnetId) ? subnetId : null
  }
  zones: skuName == 'Premium' ? pickZones('Microsoft.Cache', 'redis', location, 1) : null
}

resource redisConnectionStringSecret 'Microsoft.KeyVault/vaults/secrets@2018-02-14' = {
  name: 'redisConStrSecret'
  parent: keyVault
  properties: {
    value: '${redisCache.properties.hostName},password=${redisCache.listKeys().primaryKey},ssl=True,abortConnect=False' //'${name}.redis.cache.windows.net,abortConnect=false,ssl=true,password=${listKeys(redis.id, redis.apiVersion).primaryKey}'
  }
} 

resource redisCache_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if ( !empty(diagnosticWorkspaceId) ) {
  name: diagnosticSettingsName
  properties: {
    storageAccountId:  null 
    workspaceId: empty(diagnosticWorkspaceId) ? null : diagnosticWorkspaceId
    eventHubAuthorizationRuleId: null 
    eventHubName:  null
    metrics: empty(diagnosticWorkspaceId) ? null : diagnosticsMetrics
    logs:  empty(diagnosticWorkspaceId) ? null : diagnosticsLogs
  }
  scope: redisCache
}

resource keyVault 'Microsoft.KeyVault/vaults@2022-11-01' existing = {
  name: keyvaultName
}
