targetScope = 'resourceGroup'

type obj = {
  level: 'bronze' | 'silver' | 'gold'
}

type oneOfSeveralObjects = {foo: 'bar'} | {fizz: 'buzz'} | {snap: 'crackle'}
type mixedTypeArray = ('fizz' | 42 | {an: 'object'} | null)[]

metadata singleExpressionMetaData = 'something'

metadata objectMetaData = {
  author: 'Someone'
  description: 'Something'
}

@description('Required. The name of the Redis cache resource. Start and end with alphanumeric. Consecutive hyphens not allowed')
@maxLength(63)
@minLength(1)
param name string

@description('The name of an existing keyvault, that it will be used to store secrets (connection string)' )
param keyvaultName string

// @description('Optional. Enables system assigned managed identity on the resource.')
// param systemAssignedIdentity bool = false

// @description('Optional. The ID(s) to assign to the resource.')
// param userAssignedIdentities object = {}

@description('Optional. The name of the diagnostic setting, if deployed.')
param diagnosticSettingsName string = '${name}-diagnosticSettings'

@description('Optional. Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
param diagnosticWorkspaceId string = ''

@description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource.')
@allowed([
  'allLogs'
  'ConnectedClientList'
])
param diagnosticLogCategoriesToEnable array = [
  'allLogs'
]

@description('Optional. The name of metrics that will be streamed.')
@allowed([
  'AllMetrics'
])
param diagnosticMetricsToEnable array = [
  'AllMetrics'
]

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

var dogs = [
  {
    name: 'Fido'
    age: 3
  }
  {
    name: 'Rex'
    age: 7
  }
]

// var identityType = systemAssignedIdentity ? 'SystemAssigned' : !empty(userAssignedIdentities) ? 'UserAssigned' : 'None'

// var identity = {
//   type: identityType
//   userAssignedIdentities: !empty(userAssignedIdentities) ? userAssignedIdentities : null
// }

module singleModuleWithIndexedDependencies 'passthrough.bicep' = {
  name: 'hello'
  params: {
    myInput: concat(moduleCollectionWithCollectionDependencies[index].outputs.myOutput, storageAccounts[index * 3].properties.accessTier)
  }
  dependsOn: [
    storageAccounts2[index - 10]
  ]
}

module moduleCollectionWithIndexedDependencies 'passthrough.bicep' = [for moduleName in moduleSetup: {
  name: moduleName
  params: {
    myInput: '${moduleCollectionWithCollectionDependencies[index].outputs.myOutput} - ${storageAccounts[index * 3].properties.accessTier} - ${moduleName}'
  }
  dependsOn: [
    storageAccounts2[index - 9]
  ]
}]

resource keyVault 'Microsoft.KeyVault/vaults@2022-11-01' existing = {
  name: keyvaultName
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
  scope: resourceGroup()
}

@description('The resource name.')
output name string = subscription().displayName

output oldDogs array = filter(dogs, dog => dog.age >=5)
