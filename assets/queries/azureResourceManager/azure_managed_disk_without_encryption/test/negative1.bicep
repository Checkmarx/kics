@description('Specifies a name for generating resource names.')
param projectName string

var vmName = '${projectName}-vm'

resource vmName_disk1 'Microsoft.Compute/disks@2020-09-30' = {
  name: '${vmName}-disk1'
  location: resourceGroup().location
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    creationData: {
      createOption: 'Empty'
    }
    diskSizeGB: 512
    encryptionSettingsCollection: {
      enabled: true
      encryptionSettings: [
        {
          diskEncryptionKey: {
            secretUrl: 'https://secret.com/secrets/secret'
            sourceVault: {
              id: '/someid/somekey'
            }
          }
        }
      ]
    }
  }
}
