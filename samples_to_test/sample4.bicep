param env string = 'demo'
param appName string = 'sample-webapp'
param location string = resourceGroup().location
param appServicePlanId string = '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-rg/providers/Microsoft.Web/serverfarms/example-plan'

var webAppName = '${appName}-${env}'

resource webApp 'Microsoft.Web/sites@2025-03-01' = {
  name: webAppName
  location: location
  kind: 'app,linux'
  properties: {
    reserved: true
    httpsOnly: true
    serverFarmId: appServicePlanId
  }
}

resource webAppLogsConfig 'Microsoft.Web/sites/config@2025-03-01' = {
  parent: webApp
  name: 'logs'
  properties: {
    applicationLogs: {
      fileSystem: {
        level: 'Information'
      }
    }
    detailedErrorMessages: {
      enabled: true
    }
    failedRequestsTracing: {
      enabled: true
    }
    httpLogs: {
      fileSystem: {
        enabled: true
        retentionInDays: 30
        retentionInMb: 100
      }
    }
  }
}

resource webAppWebConfig 'Microsoft.Web/sites/config@2025-03-01' = {
  parent: webApp
  name: 'web'
  properties: {
    alwaysOn: true
    linuxFxVersion: 'NODE|22-lts'
    http20Enabled: true
    appCommandLine: 'pm2 serve /home/site/wwwroot --no-daemon --spa'
    minTlsVersion: '1.2'
    scmMinTlsVersion: '1.2'
    ftpsState: 'Disabled'
  }
  dependsOn: [
    webAppLogsConfig
  ]
}
