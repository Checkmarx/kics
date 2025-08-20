@description('Nome do servidor SQL')
param sqlServerName string = 'my-sql-server'

@description('Localização do recurso')
param location string = resourceGroup().location

@description('Login do administrador')
param administratorLogin string = 'sqladminuser'

@secure()
@description('Password do administrador')
param administratorLoginPassword string

resource sqlServer 'Microsoft.Sql/servers@2022-05-01-preview' = {
  name: sqlServerName
  location: location
  properties: {
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
  }
}

resource auditingSetting 'Microsoft.Sql/servers/auditingSettings@2022-05-01-preview' = {
  name: 'default' 
  parent: sqlServer
  properties: {
    state: 'Enabled'
    isAzureMonitorTargetEnabled: true
    retentionDays: 89
  }
}

resource auditingSetting2 'Microsoft.Sql/servers/databases@2022-05-01-preview' = {
  name: 'default' 
  parent: sqlServer
  properties: {
    state: 'Enabled'
    isAzureMonitorTargetEnabled: true
    retentionDays: 89
  }
}
