resource negative1 'Microsoft.Synapse/workspaces@2021-06-01' = {
  name: 'negative1'
  location: 'location1'
  properties: {
    defaultDataLakeStorage: {
      accountUrl: 'https://accountname.dfs.core.windows.net'
      filesystem: 'filesystem1'
    }
    sqlAdministratorLogin: 'sqladminuser'
    managedVirtualNetwork: 'default'
  }
}
