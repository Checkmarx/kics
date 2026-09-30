# "Generic Password" - 487f4be7-3fd9-4506-a07a-eae252180c08 - "Avoiding description field"               allow-rule-test - #1
# "Generic Password" - 487f4be7-3fd9-4506-a07a-eae252180c08 - "Avoiding Terraform 'optional' statement"  allow-rule-test - #2
# "Generic Password" - 487f4be7-3fd9-4506-a07a-eae252180c08 - "Avoiding Terraform 'try' statement"       allow-rule-test - #3
variable "linux_vms" {
  # 1:
  description = "A list of the Linux VMs to create.  \n <a name=region:></a>[region:](#region:) The Azure location where the Windows Virtual Machine should exist. Changing this forces a new resource to be created.  \n <a name=size:></a>[size:](#size:) The SKU which should be used for this Virtual Machine, such as Standard_F2.  \n <a name=admin_username:></a>[admin_username:](#admin_username:) The username of the local administrator used for the Virtual Machine. Changing this forces a new resource to be created.  \n <a name=admin_password:></a>[admin_password:](#admin_password:) he Password which should be used for the local-administrator on this Virtual Machine. Changing this forces a new resource to be created."
  type = map(object({
    region                           = string
    size                             = optional(string)
    admin_username                   = optional(string)
    admin_password                   = optional(string) #2
  }))
  default = {}
}

resource "azurerm_linux_virtual_machine" "vms" {
  admin_password        = try(each.value.admin_password, null)  #3
}