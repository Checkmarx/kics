@description('Specifies a username for the Virtual Machine.')
param adminUsername string

@secure()
param adminPassword string

param location string = resourceGroup().location

param vmSize string = 'Standard_D2s_v3'

resource winByConfig 'Microsoft.Compute/virtualMachines@2021-03-01' = {
  name: 'winByConfig'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: 'winByConfig'
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

resource winByOsType 'Microsoft.Compute/virtualMachines@2021-03-01' = {
  name: 'winByOsType'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: 'winByOsType'
      adminUsername: adminUsername
    }
    storageProfile: {
      imageReference: {
        id: '/subscriptions/x/resourceGroups/rg/providers/Microsoft.Compute/images/customImage'
      }
      osDisk: {
        createOption: 'fromImage'
        osType: 'Windows'
      }
    }
  }
}

resource linuxByConfig 'Microsoft.Compute/virtualMachines@2021-03-01' = {
  name: 'linuxByConfig'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: 'linuxByConfig'
      adminUsername: adminUsername
      linuxConfiguration: {
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
