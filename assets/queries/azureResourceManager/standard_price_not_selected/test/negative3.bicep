@description(
  'Name of the central Log Analytics workspace that stores security event and data collected by Azure Security Center'
)
@allowed(['az-security-workspace'])
param workspaceName string = 'az-security-workspace'

@description(
  'Name of the resource group where the central log analytics workspace belongs to'
)
@allowed(['azsec-security-rg'])
param workspaceRgName string = 'azsec-security-rg'

@description('Specify whether Auto Provisoning is turned on or off')
@allowed(['On', 'Off'])
param autoProvisionSetting string = 'On'

@description(
  'Email of the administrator who should be notified about Azure Security Center alert'
)
param ascOwnerEmail string

@description(
  'Phone number of the administrator should be notified about Azure Security Center alert'
)
param ascOwnerContact string

@description(
  'Specify whether you want to notify high severity alert to ASC administrator'
)
@allowed(['On', 'Off'])
param highSeverityAlertNotification string = 'On'

@description(
  'Specifiy whether you want to notify high severity alert to subscription owner'
)
@allowed(['On', 'Off'])
param subscriptionOwnerNotification string = 'On'

@description(
  'Specifiy whether you want to enable Standard tier for Virtual Machine resource type'
)
@allowed(['Standard', 'Free'])
param virtualMachineTier string = 'Standard'

@description(
  'Specify whether you want to enable Standard tier for Azure App Service resource type'
)
@allowed(['Standard', 'Free'])
param appServiceTier string = 'Standard'

@description(
  'Specify whether you want to enable Standard tier for PaaS SQL Service resource type'
)
@allowed(['Standard', 'Free'])
param paasSQLServiceTier string = 'Standard'

@description(
  'Specify whether you want to enable Standard tier for SQL Server on VM resource type'
)
@allowed(['Standard', 'Free'])
param sqlServerOnVmTier string = 'Standard'

@description(
  'Specify whether you want to enable Standard tier for Storage Account resource type'
)
@allowed(['Standard', 'Free'])
param storageAccountTier string = 'Standard'

@description(
  'Specify whether you want to enable Standard tier for Kubernetes service resource type'
)
@allowed(['Standard', 'Free'])
param kubernetesServiceTier string = 'Standard'

@description(
  'Specify whether you want to enable Standard tier for Container Registry resource type'
)
@allowed(['Standard', 'Free'])
param containerRegistryTier string = 'Standard'

@description(
  'Specify whether you want to enable Standard tier for Key Vault resource type'
)
@allowed(['Standard', 'Free'])
param keyvaultTier string = 'Standard'

@description(
  'Select integration name to enable. Only MCAS or MDATP is supported.'
)
@allowed(['MCAS', 'MDATP'])
param integrationName string

@description('Specify whether you want to enable or not.')
@allowed([true, false])
param integrationEnabled bool

resource default 'Microsoft.Security/workspaceSettings@2017-08-01-preview' = {
  name: 'default'
  properties: {
    scope: subscription().id
    workspaceId: '${subscription().id}/resourceGroups/${workspaceRgName}/providers/Microsoft.OperationalInsights/workspaces/${workspaceName}'
  }
}

resource Microsoft_Security_autoProvisioningSettings_default 'Microsoft.Security/autoProvisioningSettings@2017-08-01-preview' = {
  name: 'default'
  properties: {
    autoProvision: autoProvisionSetting
  }
}

resource default1 'Microsoft.Security/securityContacts@2017-08-01-preview' = {
  name: 'default1'
  properties: {
    emails: ascOwnerEmail
    phone: ascOwnerContact
    alertNotifications: {
      state: 'On'
      minimalSeverity: highSeverityAlertNotification
    }
    notificationsByRole: {
      state: 'On'
      roles: subscriptionOwnerNotification
    }
  }
}

resource VirtualMachines 'Microsoft.Security/pricings@2018-06-01' = {
  name: 'VirtualMachines'
  properties: {
    pricingTier: virtualMachineTier
  }
}

resource AppServices 'Microsoft.Security/pricings@2018-06-01' = {
  name: 'AppServices'
  properties: {
    pricingTier: appServiceTier
  }
  dependsOn: [VirtualMachines]
}

resource SqlServers 'Microsoft.Security/pricings@2018-06-01' = {
  name: 'SqlServers'
  properties: {
    pricingTier: paasSQLServiceTier
  }
  dependsOn: [AppServices]
}

resource SqlServerVirtualMachines 'Microsoft.Security/pricings@2018-06-01' = {
  name: 'SqlServerVirtualMachines'
  properties: {
    pricingTier: sqlServerOnVmTier
  }
  dependsOn: [SqlServers]
}

resource StorageAccounts 'Microsoft.Security/pricings@2018-06-01' = {
  name: 'StorageAccounts'
  properties: {
    pricingTier: storageAccountTier
  }
  dependsOn: [SqlServerVirtualMachines]
}

resource KubernetesService 'Microsoft.Security/pricings@2018-06-01' = {
  name: 'KubernetesService'
  properties: {
    pricingTier: kubernetesServiceTier
  }
  dependsOn: [StorageAccounts]
}

resource ContainerRegistry 'Microsoft.Security/pricings@2018-06-01' = {
  name: 'ContainerRegistry'
  properties: {
    pricingTier: containerRegistryTier
  }
  dependsOn: [KubernetesService]
}

resource KeyVaults 'Microsoft.Security/pricings@2018-06-01' = {
  name: 'KeyVaults'
  properties: {
    pricingTier: keyvaultTier
  }
  dependsOn: [ContainerRegistry]
}

resource integration 'Microsoft.Security/settings@2019-01-01' = {
  name: integrationName
  kind: 'DataExportSettings'
  properties: {
    enabled: integrationEnabled
  }
}
