param dataDirectory string
param maxSizeMB string
param minSizeMB string
param pageSizeMB string
param workMemMB string
param maintenanceMemMB string
param checkpointSegments string
param checkpointCompletionTarget string

resource MyDBServer1 'Microsoft.DBforPostgreSQL/servers@2017-12-01' = {
  kind: ''
  location: resourceGroup().location
  name: 'MyDBServer1'
  properties: {
    sslEnforcement: 'Disabled'
    version: '11'
    administratorLogin: 'root'
    administratorLoginPassword: '12345'
    storageMB: '2048'
    createMode: 'Default'
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    creationDate: '2019-04-01T00:00:00Z'
    lastModifiedDate: '2019-04-01T00:00:00Z'
    maxSizeUnits: 'SizeUnit.megabytes'
    isReadOnly: 'false'
    isAutoUpgradeEnabled: 'true'
    isStateful: 'false'
    isExternal: 'false'
  }
  sku: {
    name: 'S0'
    tier: 'Basic'
    capacity: 1
    family: 'GeneralPurpose'
  }
}

resource MyDBServer1_log_checkpoints 'Microsoft.DBforPostgreSQL/servers/configurations@2017-12-01' = {
  parent: MyDBServer1
  name: 'log_checkpoints'
  properties: {
    configurationSets: [
      {
        configurationSetType: 'Microsoft.DBforPostgreSQL/servers/configurations/dbconfig'
        configurationSet: {
          name: 'dbconfig'
          configurationParameters: [
            {
              name: 'data_directory'
              value: dataDirectory
            }
            {
              name: 'max_size'
              value: maxSizeMB
            }
            {
              name: 'min_size'
              value: minSizeMB
            }
            {
              name: 'page_size'
              value: pageSizeMB
            }
            {
              name: 'work_mem'
              value: workMemMB
            }
            {
              name: 'maintenance_work_mem'
              value: maintenanceMemMB
            }
            {
              name: 'checkpoint_segments'
              value: checkpointSegments
            }
            {
              name: 'checkpoint_completion_target'
              value: checkpointCompletionTarget
            }
          ]
        }
      }
    ]
  }
  location: resourceGroup().location
  dependsOn: [
    'Microsoft.DBforPostgreSQL/servers/MyDBServer'
  ]
}
