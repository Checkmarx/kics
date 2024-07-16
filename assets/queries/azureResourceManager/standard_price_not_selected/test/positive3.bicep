@description(
  'Specifiy whether you want to enable Standard tier for Virtual Machine resource type'
)
@allowed(['Standard', 'Free'])
param virtualMachineTier string = 'Free'

resource VirtualMachines 'Microsoft.Security/pricings@2018-06-01' = {
  name: 'VirtualMachines'
  properties: {
    pricingTier: virtualMachineTier
  }
}
