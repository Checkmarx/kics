@description('The name of the VM')
param virtualMachineName string = 'myVM'

@description('The virtual machine size.')
param virtualMachineSize string = 'Standard_D8s_v3'

@description('Specify the name of an existing VNet in the same resource group')
param existingVirtualNetworkName string

@description('Specify the resrouce group of the existing VNet')
param existingVnetResourceGroup string = resourceGroup().name

@description('Specify the name of the Subnet Name')
param existingSubnetName string

@description('Windows Server and SQL Offer')
@allowed(
  [
    'sql2019-ws2019'
    'sql2017-ws2019'
    'SQL2017-WS2016'
    'SQL2016SP1-WS2016'
    'SQL2016SP2-WS2016'
    'SQL2014SP3-WS2012R2'
    'SQL2014SP2-WS2012R2'
  ]
)
param imageOffer string = 'sql2019-ws2019'

@description('SQL Server Sku')
@allowed(['Standard', 'Enterprise', 'SQLDEV', 'Web', 'Express'])
param sqlSku string = 'Standard'

@description('Zone to deploy to')
@allowed([1, 2, 3])
param zone int = 1

@description('The admin user name of the VM')
param adminUsername string

@description('The admin password of the VM')
@secure()
param adminPassword string

@description('SQL Server Workload Type')
@allowed(['General', 'OLTP', 'DW'])
param storageWorkloadType string = 'General'

@description('Amount of data disks (1TB each) for SQL Data files')
@minValue(1)
@maxValue(8)
param sqlDataDisksCount int = 1

@description(
  'Path for SQL Data files. Please choose drive letter from F to Z, and other drives from A to E are reserved for system'
)
param dataPath string = 'F:\\SQLData'

@description('SQL Log UltraSSD Disk size in GiB.')
param sqlLogUltraSSDDiskSizeInGB int = 512

@description(
  'SQL Log UltraSSD Disk IOPS value representing the maximum IOPS that the disk can achieve.'
)
param sqlLogUltraSSDdiskIOPSReadWrite int = 20000

@description(
  'SQL Log UltraSSD Disk MBps value representing the maximum throughput that the disk can achieve.'
)
param sqlLogUltraSSDdiskMbpsReadWrite int = 500

@description(
  'Path for SQL Log files. Please choose drive letter from F to Z and different than the one used for SQL data. Drive letter from A to E are reserved for system'
)
param logPath string = 'G:\\SQLLog'

@description('Location for all resources.')
@allowed(['East US 2', 'SouthEast Asia', 'North Europe'])
param location string

var networkInterfaceName = '${virtualMachineName}-nic'
var networkSecurityGroupName = '${virtualMachineName}-nsg'
var networkSecurityGroupRules = [
  {
    name: 'RDP'
    properties: {
      priority: 300
      protocol: 'TCP'
      access: 'Allow'
      direction: 'Inbound'
      sourceAddressPrefix: '*'
      sourcePortRange: '*'
      destinationAddressPrefix: '*'
      destinationPortRange: '3389'
    }
  }
]
var publicIpAddressName = '${virtualMachineName}-publicip-${uniqueString(virtualMachineName)}'
var publicIpAddressType = 'Dynamic'
var publicIpAddressSku = 'Basic'
var diskConfigurationType = 'NEW'
var nsgId = networkSecurityGroup.id
var subnetRef = resourceId(
  existingVnetResourceGroup,
  'Microsoft.Network/virtualNetWorks/subnets',
  existingVirtualNetworkName,
  existingSubnetName
)
var dataDisksLuns = array(range(0, sqlDataDisksCount))
var logDisksLuns = array(range(sqlDataDisksCount, 1))
var dataDisks = {
  createOption: 'empty'
  caching: 'ReadOnly'
  writeAcceleratorEnabled: false
  storageAccountType: 'Premium_LRS'
  diskSizeGB: 1023
}
var tempDbPath = 'D:\\SQLTempdb'

resource virtualMachineName_dataDisk_UltraSSD 'Microsoft.Compute/disks@2019-11-01' = [
  for i in range(0, 1): {
    name: '${virtualMachineName}-dataDisk-UltraSSD-${i}'
    location: location
    sku: {
      name: 'UltraSSD_LRS'
    }
    zones: [zone]
    properties: {
      creationData: {
        createOption: 'Empty'
      }
      encryptionSettingsCollection: {
        enabled: false
        encryptionSettings: [
          {
            diskEncryptionKey: {
              sourceVault: {
                id: '/subscriptions/{subscriptionId}/resourceGroups/myResourceGroup/providers/Microsoft.KeyVault/vaults/myVMVault'
              }
              secretUrl: 'https://myvmvault.vault-int.azure-int.net/secrets/{secret}'
            }
            keyEncryptionKey: {
              sourceVault: {
                id: '/subscriptions/{subscriptionId}/resourceGroups/myResourceGroup/providers/Microsoft.KeyVault/vaults/myVMVault'
              }
              keyUrl: 'https://myvmvault.vault-int.azure-int.net/keys/{key}'
            }
          }
        ]
      }
      diskSizeGB: sqlLogUltraSSDDiskSizeInGB
      diskIOPSReadWrite: sqlLogUltraSSDdiskIOPSReadWrite
      diskMBpsReadWrite: sqlLogUltraSSDdiskMbpsReadWrite
    }
  }
]

resource publicIpAddress 'Microsoft.Network/publicIpAddresses@2020-05-01' = {
  name: publicIpAddressName
  location: location
  sku: {
    name: publicIpAddressSku
  }
  zones: [zone]
  properties: {
    publicIPAllocationMethod: publicIpAddressType
  }
}

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2020-05-01' = {
  name: networkSecurityGroupName
  location: location
  properties: {
    securityRules: networkSecurityGroupRules
  }
}

resource networkInterface 'Microsoft.Network/networkInterfaces@2020-05-01' = {
  name: networkInterfaceName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: subnetRef
          }
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIpAddress.id
          }
        }
      }
    ]
    enableAcceleratedNetworking: true
    networkSecurityGroup: {
      id: nsgId
    }
  }
}

resource virtualMachine 'Microsoft.Compute/virtualMachines@2019-12-01' = {
  name: virtualMachineName
  location: location
  zones: [zone]
  properties: {
    hardwareProfile: {
      vmSize: virtualMachineSize
    }
    additionalCapabilities: {
      ultraSSDEnabled: 'true'
    }
    storageProfile: {
      osDisk: {
        createOption: 'fromImage'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
      }
      imageReference: {
        publisher: 'MicrosoftSQLServer'
        offer: imageOffer
        sku: sqlSku
        version: 'latest'
      }
      dataDisks: [
        for j in range(0, (sqlDataDisksCount + 1)): {
          lun: j
          createOption: 'attach'
          caching: ((j >= sqlDataDisksCount) ? 'None' : dataDisks.caching)
          managedDisk: {
            id: ((j >= sqlDataDisksCount)
              ? resourceId(
                  'Microsoft.Compute/disks/',
                  '${virtualMachineName}-dataDisk-UltraSSD-0'
                )
              : resourceId(
                  'Microsoft.Compute/disks/',
                  '${virtualMachineName}-dataDisk-${j}'
                ))
          }
        }
      ]
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterface.id
        }
      ]
    }
    osProfile: {
      computerName: virtualMachineName
      adminUsername: adminUsername
      adminPassword: adminPassword
      windowsConfiguration: {
        enableAutomaticUpdates: true
        provisionVMAgent: true
      }
    }
  }
  dependsOn: [virtualMachineName_dataDisk_UltraSSD, 'PremiumSSDLoop']
}

resource Microsoft_SqlVirtualMachine_SqlVirtualMachines_virtualMachine 'Microsoft.SqlVirtualMachine/SqlVirtualMachines@2017-03-01-preview' = {
  name: virtualMachineName
  location: location
  properties: {
    virtualMachineResourceId: virtualMachine.id
    sqlManagement: 'Full'
    sqlServerLicenseType: 'PAYG'
    storageConfigurationSettings: {
      diskConfigurationType: diskConfigurationType
      storageWorkloadType: storageWorkloadType
      sqlDataSettings: {
        luns: dataDisksLuns
        defaultFilePath: dataPath
      }
      sqlLogSettings: {
        luns: logDisksLuns
        defaultFilePath: logPath
      }
      sqlTempDbSettings: {
        defaultFilePath: tempDbPath
      }
    }
  }
}
