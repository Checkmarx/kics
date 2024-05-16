@description('Username for the Virtual Machine.')
param adminUsername string

@description('Password for the Virtual Machine.')
@minLength(12)
@secure()
param adminPassword string

@description(
  'The Windows version for the VM. This will pick a fully patched image of this given Windows version.'
)
@allowed(
  [
    '2008-R2-SP1'
    '2012-Datacenter'
    '2012-R2-Datacenter'
    '2016-Nano-Server'
    '2016-Datacenter-with-Containers'
    '2016-Datacenter'
    '2019-Datacenter'
    '2019-Datacenter-Core'
    '2019-Datacenter-Core-smalldisk'
    '2019-Datacenter-Core-with-Containers'
    '2019-Datacenter-Core-with-Containers-smalldisk'
    '2019-Datacenter-smalldisk'
    '2019-Datacenter-with-Containers'
    '2019-Datacenter-with-Containers-smalldisk'
  ]
)
param OSVersion string = '2019-Datacenter'

@description('Size of the virtual machine.')
param vmSize string = 'Standard_D2_v3'

@description('Location for all resources.')
param location string = resourceGroup().location

@description('Name of the virtual machine.')
param vmName string = 'simple-vm'

var storageAccountName = 'bootdiags${uniqueString(resourceGroup().id)}'
var nicName = 'myVMNic'

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
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: OSVersion
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
        }
      }
      dataDisks: [
        {
          diskSizeGB: 1023
          lun: 0
          createOption: 'Empty'
        }
      ]
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: resourceId('Microsoft.Network/networkInterfaces', nicName)
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
        storageUri: reference(
          resourceId('Microsoft.Storage/storageAccounts', storageAccountName)
        ).primaryEndpoints.blob
      }
    }
  }
  dependsOn: [
    resourceId('Microsoft.Network/networkInterfaces', nicName)
    resourceId('Microsoft.Storage/storageAccounts', storageAccountName)
  ]
}
