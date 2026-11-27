@description('Specifies a username for the Virtual Machine.')
param adminUsername string

@secure()
param adminPassword string

param location string = resourceGroup().location

param vmSize string = 'Standard_D2s_v3'

resource winByConfigOnly 'Microsoft.Compute/virtualMachines@2021-03-01' = {
  name: 'winByConfigOnly'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: 'winByConfigOnly'
      adminUsername: adminUsername
      windowsConfiguration: {
        provisionVMAgent: true
      }
    }
    storageProfile: {
      imageReference: {
        id: '/subscriptions/x/resourceGroups/rg/providers/Microsoft.Compute/images/customImage'
      }
      osDisk: {
        createOption: 'fromImage'
      }
    }
  }
}
