@description('Name of the Web App')
param webAppName string = 'demo-webapp'

@description('Deployment location')
param location string = 'westeurope'

@description('Resource ID of the App Service plan')
param appServicePlanId string = '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/demo-rg/providers/Microsoft.Web/serverfarms/demo-plan'

@description('Resource ID of the user-assigned managed identity')
param userAssignedIdentityResourceId string = '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/demo-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/demo-identity'

resource webApp 'Microsoft.Web/sites@2020-06-01' = {
  name: webAppName
  location: location
  kind: 'app'
  identity: {
    type: 'SystemAssigned, UserAssigned'
    userAssignedIdentities: {
      '${userAssignedIdentityResourceId}': {}
    }
  }
  properties: {
    serverFarmId: appServicePlanId
  }
}
