@description(
  'Username for the Virtual Machine.'
)
param adminUsername string

@description('Password for the Virtual Machine.')
@minLength(12)
@secure()
param adminPassword string

@description(
  '''The Windows version for the VM.
 This will pick a fully patched image of this given Windows version.'''
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

param parenthesis string = ('simple-vm')

@description('Name of the virtual network to use for cloud shell containers.')
param existingVNETName string

@description('Name of the subnet to use for storage account.')
param existingStorageSubnetName string

@description('Name of the subnet to use for cloud shell containers.')
param existingContainerSubnetName string

var storageAccountName = 'bootdiags${uniqueString(resourceGroup().id)}'

var nicName = 'myVMNic'

var containerSubnetRef = resourceId(
  'Microsoft.Network/virtualNetworks/subnets',
  existingVNETName,
  existingContainerSubnetName
)

var storageSubnetRef = resourceId(
  'Microsoft.Network/virtualNetworks/subnets',
  existingVNETName,
  existingStorageSubnetName
)

@sys.description('This is a test description for resources')
resource vm 'Microsoft.Compute/virtualMachines@2021-03-01' = {
  name: vmName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: 'computer'.vmName
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
          id: resourceId('Microsoft.Network/networkInterfaces', 'nick'.nicName)
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

resource nic 'Microsoft.Network/networkInterfaces@2021-03-01' = {
  name: nicName[0]
  location: [
    for i in name: {
      name: nicName
    }
  ]
  userAssignedIdentities: {
    '${resourceId('Microsoft.ManagedIdentity/userAssignedIdentities',nicName)}': {}
  }
  assignableScopes: [subscription().id]
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  kind: 'StorageV2'
  properties: {
    networkAcls: {
      bypass: 'None'
      virtualNetworkRules: [
        {
          id: containerSubnetRef
          action: 'Allow'
        }
        {
          id: storageSubnetRef
          action: 'Allow'
        }
      ]
      defaultAction: 'Deny'
    }
    supportsHttpsTrafficOnly: true
    encryption: {
      services: {
        file: {
          keyType: 'Account'
          enabled: true
        }
        blob: {
          keyType: 'Account'
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
    accessTier: 'Cool'
  }
}

resource storageAccountName_default 'Microsoft.Storage/storageAccounts/blobServices@2019-06-01' = {
  parent: storageAccount
  name: 'default'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  properties: {
    deleteRetentionPolicy: {
      enabled: false
    }
  }
}

resource storageAccountName_default_container 'Microsoft.Storage/storageAccounts/blobServices/containers@2019-06-01' = {
  parent: storageAccountName_default
  name: 'container'
  properties: {
    denyEncryptionScopeOverride: true
    publicAccess: 'Blob'
    metadata: {}
  }
}
