@description('Specifies a username for the Virtual Machine.')
param adminUsername string

@secure()
param adminPassword string

param location string = resourceGroup().location

param vmSize string = 'Standard_D2s_v3'

resource unknownOs 'Microsoft.Compute/virtualMachines@2021-03-01' = {
  name: 'unknownOs'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: 'unknownOs'
      adminUsername: adminUsername
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
