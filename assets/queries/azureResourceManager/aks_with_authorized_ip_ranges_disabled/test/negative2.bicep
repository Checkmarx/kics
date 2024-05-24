resource aksCluster1 'Microsoft.ContainerService/managedClusters@2019-02-01' = {
  name: 'aksCluster1'
  location: resourceGroup().location
  properties: {
    kubernetesVersion: '1.15.7'
    dnsPrefix: 'dnsprefix'
    agentPoolProfiles: [
      {
        name: 'agentpool'
        count: 2
        vmSize: 'Standard_A1'
        osType: 'Linux'
        storageProfile: 'ManagedDisks'
      }
    ]
    linuxProfile: {
      adminUsername: 'adminUserName'
      ssh: {
        publicKeys: [
          {
            keyData: 'keyData'
          }
        ]
      }
    }
    servicePrincipalProfile: {
      clientId: 'servicePrincipalAppId'
      secret: 'servicePrincipalAppPassword'
    }
    apiServerAuthorizedIPRanges: ['192.168.0.1', '192.168.0.18']
  }
}
