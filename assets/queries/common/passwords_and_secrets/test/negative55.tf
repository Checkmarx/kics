
variable "linux_vms" {
  description = "A list of the Linux VMs to create.  \n <a name=region:></a>[region:](#region:) The Azure location where the Windows Virtual Machine should exist. Changing this forces a new resource to be created.  \n <a name=size:></a>[size:](#size:) The SKU which should be used for this Virtual Machine, such as Standard_F2.  \n <a name=admin_username:></a>[admin_username:](#admin_username:) The username of the local administrator used for the Virtual Machine. Changing this forces a new resource to be created.  \n <a name=admin_password:></a>[admin_password:](#admin_password:) he Password which should be used for the local-administrator on this Virtual Machine. Changing this forces a new resource to be created."
  type = map(object({
    region                           = string
    size                             = optional(string)
    admin_username                   = optional(string)
    admin_password                   = optional(string)
  }))
  default = {}
}

resource "azurerm_linux_virtual_machine" "vms" {
  admin_password        = try(each.value.admin_password, null)
}