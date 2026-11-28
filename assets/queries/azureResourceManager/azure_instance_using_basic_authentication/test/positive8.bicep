@description('Specifies a username for the Virtual Machine.')
param adminUsername string

@secure()
param adminPassword string

param location string = resourceGroup().location

param vmSize string = 'Standard_D2s_v3'

resource winPublisherOnly 'Microsoft.Compute/virtualMachines@2021-03-01' = {
  name: 'winPublisherOnly'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: 'winPublisherOnly'
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2019-Datacenter'
        version: 'latest'
      }
      osDisk: {
        createOption: 'fromImage'
      }
    }
  }
}

resource winThirdPartyPublisher 'Microsoft.Compute/virtualMachines@2021-03-01' = {
  name: 'winThirdPartyPublisher'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: 'winThirdPartyPublisher'
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'microsoft-ads'
        offer: 'windows-data-science-vm'
        sku: 'windows2016'
        version: 'latest'
      }
      osDisk: {
        createOption: 'fromImage'
      }
    }
  }
}

resource azureLinuxPublisher 'Microsoft.Compute/virtualMachines@2021-03-01' = {
  name: 'azureLinuxPublisher'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: 'azureLinuxPublisher'
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'microsoftazurelinux'
        offer: 'azurelinux-4'
        sku: '4'
        version: 'latest'
      }
      osDisk: {
        createOption: 'fromImage'
      }
    }
  }
}
