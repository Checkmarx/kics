@description('Specifies a name for generating resource names.')
param projectName string

@description('Specifies the location for all resources.')
param location string = resourceGroup().location

@description('Specifies a username for the Virtual Machine.')
param adminUsername string

@description(
  'Specifies the SSH rsa public key file as a string. Use "ssh-keygen -t rsa -b 2048" to generate your SSH key pairs.'
)
param adminPublicKey string

@description('description')
param vmSize string = 'Standard_D2s_v3'

var vmName = '${projectName}-vm'
var networkInterfaceName = '${projectName}-nic'

resource vm 'Microsoft.Compute/virtualMachines@2021-03-01' = {
  name: vmName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      linuxConfiguration: {
        disablePasswordAuthentication: true
        ssh: {
          publicKeys: [
            {
              path: '/home/${adminUsername}/.ssh/authorized_keys'
              keyData: adminPublicKey
            }
          ]
        }
      }
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: 'UbuntuServer'
        sku: '18.04-LTS'
        version: 'latest'
      }
      osDisk: {
        createOption: 'fromImage'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: resourceId(
            'Microsoft.Network/networkInterfaces',
            networkInterfaceName
          )
        }
      ]
    }
  }
  dependsOn: [
    resourceId('Microsoft.Network/networkInterfaces', networkInterfaceName)
  ]
}
