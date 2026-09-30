# "Generic Password" - 487f4be7-3fd9-4506-a07a-eae252180c08  positive-test
variable "linux_vms" {
  description = "positive54.tf"
  type = map(object({
    region                           = string
    size                             = optional(string)
    admin_username                   = optional(string)
    admin_password                   = "optional(sensitive(string))"  # positive1
  }))
  default = {}
}

resource "azurerm_linux_virtual_machine" "vms" {
  admin_password        = try(each.value.admin_password, "exposed_password", null)  # positive2
}