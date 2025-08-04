
######
# azurerm_linux_virtual_machine
######

variable "resource_group_name" {
  description = "The name of the resource group in which to create the virtual network"
  type        = string
}

variable "location" {
  description = "The location/region where the virtual network is created"
  type        = string
  default     = ""
}

variable "linux_vms" {
  description = "A list of the Linux VMs to create.  \n <a name=region:></a>[region:](#region:) The Azure location where the Windows Virtual Machine should exist. Changing this forces a new resource to be created.  \n <a name=size:></a>[size:](#size:) The SKU which should be used for this Virtual Machine, such as Standard_F2.  \n <a name=admin_username:></a>[admin_username:](#admin_username:) The username of the local administrator used for the Virtual Machine. Changing this forces a new resource to be created.  \n <a name=admin_password:></a>[admin_password:](#admin_password:) he Password which should be used for the local-administrator on this Virtual Machine. Changing this forces a new resource to be created.  \n <a name=license_type:></a>[license_type:](#license_type:) Specifies the BYOL Type for this Virtual Machine. Possible values are RHEL_BYOS and SLES_BYOS.  \n <a name=ultra_ssd_enabled:></a>[ultra_ssd_enabled:](#ultra_ssd_enabled:) Should the capacity to enable Data Disks of the UltraSSD_LRS storage account type be supported on this Virtual Machine? Defaults to false.  \n <a name=boot_diagnostics_storage_account:></a>[boot_diagnostics_storage_account:](#boot_diagnostics_storage_account:) The Primary/Secondary Endpoint for the Azure Storage Account which should be used to store Boot Diagnostics, including Console Output and Screenshots from the Hypervisor.  \n <a name=allow_extension_operations:></a>[allow_extension_operations:](#allow_extension_operations:) Should Extension Operations be allowed on this Virtual Machine?.  \n <a name=availability_set_id:></a>[availability_set_id:](#availability_set_id:) Specifies the ID of the Availability Set in which the Virtual Machine should exist. Changing this forces a new resource to be created.  \n <a name=computer_name:></a>[computer_name:](#computer_name:) Specifies the Hostname which should be used for this Virtual Machine. If unspecified this defaults to the value for the name field. If the value of the name field is not a valid computer_name, then you must specify computer_name. Changing this forces a new resource to be created.  \n <a name=custom_data:></a>[custom_data:](#custom_data:) The File-Base64-Encoded Custom Data which should be used for this Virtual Machine. Changing this forces a new resource to be created.  \n <a name=custom_data_txt:></a>[custom_data_txt:](#custom_data_txt:) The Base64-Encoded Custom Data which should be used for this Virtual Machine. Changing this forces a new resource to be created.  \n <a name=eviction_policy:></a>[eviction_policy:](#eviction_policy:) Specifies what should happen when the Virtual Machine is evicted for price reasons when using a Spot instance. At this time the only supported value is Deallocate. Changing this forces a new resource to be created.  \n <a name=max_bid_price:></a>[max_bid_price:](#max_bid_price:) The maximum price you're willing to pay for this Virtual Machine, in US Dollars; which must be greater than the current spot price. If this bid price falls below the current spot price the Virtual Machine will be evicted using the eviction_policy. Defaults to -1, which means that the Virtual Machine should not be evicted for price reasons.  \n <a name=priority:></a>[priority:](#priority:) Specifies the priority of this Virtual Machine. Possible values are Regular and Spot. Defaults to Regular. Changing this forces a new resource to be created.  \n <a name=provision_vm_agent:></a>[provision_vm_agent:](#provision_vm_agent:) Should the Azure VM Agent be provisioned on this Virtual Machine? Defaults to true. Changing this forces a new resource to be created.  \n <a name=proximity_placement_group_id:></a>[proximity_placement_group_id:](#proximity_placement_group_id:) The ID of the Proximity Placement Group which the Virtual Machine should be assigned to.  \n <a name=zone:></a>[zone:](#zone:) Specifies the Availability Zone in which this Windows Virtual Machine should be located. Changing this forces a new Windows Virtual Machine to be created.  \n <a name=disable_password_authentication:></a>[disable_password_authentication:](#disable_password_authentication:) Should Password Authentication be disabled on this Virtual Machine? Defaults to true. Changing this forces a new resource to be created. \n <a name=virtual_machine_scale_set_id:></a>[virtual_machine_scale_set_id:](#virtual_machine_scale_set_id:)Specifies the Orchestrated Virtual Machine Scale Set that this Virtual Machine should be created within. \n <a name=timezone:></a>[timezone:](#timezone:) Specifies the Time Zone which should be used by the Virtual Machine.  \n <a name=os_disk:></a>[os_disk:](#os_disk:) os disk create in the vm. - caching: The Type of Caching which should be used for the Internal OS Disk. Possible values are None, ReadOnly and ReadWrite. - storage_account_type: The Type of Storage Account which should back this the Internal OS Disk. Possible values are Standard_LRS, StandardSSD_LRS, Premium_LRS, StandardSSD_ZRS and Premium_ZRS. Changing this forces a new resource to be created. - disk_encryption_set_id: The ID of the Disk Encryption Set which should be used to Encrypt this OS Disk. Conflicts with secure_vm_disk_encryption_set_id. - disk_size_gb: The Size of the Internal OS Disk in GB, if you wish to vary from the size used in the image this Virtual Machine is sourced from. - write_accelerator_enabled: Should Write Accelerator be Enabled for this OS Disk? Defaults to false.  \n <a name=source_image_id:></a>[source_image_id:](#source_image_id:) The ID of the Image which this Virtual Machine should be created from. Changing this forces a new resource to be created.  \n <a name=source_image_reference:></a>[source_image_reference:](#source_image_reference:) A source_image_reference block as defined below. Changing this forces a new resource to be created. - publisher: Specifies the publisher of the image used to create the virtual machines. - offer: Specifies the offer of the image used to create the virtual machines. - sku: Specifies the SKU of the image used to create the virtual machines. - version: Specifies the version of the image used to create the virtual machines.  \n <a name=admin_ssh_key:></a>[admin_ssh_key:](#admin_ssh_key:)A admin_ssh_key block supports the following. - public_key: The Public Key which should be used for authentication, which needs to be at least 2048-bit and in ssh-rsa format. Changing this forces a new resource to be created. - username: The Username for which this Public SSH Key should be configured. Changing this forces a new resource to be created.  \n <a name=identity:></a>[identity:](#identity:) An identity block supports the following. - type: Specifies the type of Managed Service Identity that should be configured on this Windows Virtual Machine. Possible values are SystemAssigned, UserAssigned, SystemAssigned, UserAssigned (to enable both). identity_ids: Specifies a list of User Assigned Managed Identity IDs to be assigned to this Windows Virtual Machine.  \n <a name=plan:></a>[plan:](#plan:) A plan block supports the following. - name: Specifies the Name of the Marketplace Image this Virtual Machine should be created from. Changing this forces a new resource to be created. - product: Specifies the Product of the Marketplace Image this Virtual Machine should be created from. Changing this forces a new resource to be created. - publisher: Specifies the Publisher of the Marketplace Image this Virtual Machine should be created from. Changing this forces a new resource to be created.  \n <a name=network_interface_ids:></a>[network_interface_ids:](#network_interface_ids:) A list of Network Interface IDs which should be attached to this Virtual Machine. The first Network Interface ID in this list will be the Primary Network Interface on the Virtual Machine."
  type = map(object({
    region                           = string
    size                             = optional(string)
    admin_username                   = optional(string)
    admin_password                   = optional(string)
    license_type                     = optional(string)
    ultra_ssd_enabled                = optional(bool)
    boot_diagnostics_storage_account = optional(string)
    allow_extension_operations       = optional(bool)
    dedicated_host_id                = optional(string)
    encryption_at_host_enabled       = optional(bool)
    availability_set_id              = optional(string)
    computer_name                    = optional(string)
    custom_data                      = optional(string)
    custom_data_txt                  = optional(string)
    eviction_policy                  = optional(string)
    max_bid_price                    = optional(number)
    priority                         = optional(string)
    provision_vm_agent               = optional(bool)
    proximity_placement_group_id     = optional(string)
    zone                             = optional(string)
    disable_password_authentication  = optional(bool)
    virtual_machine_scale_set_id     = optional(string)
    timezone                         = optional(string)
    os_disk                          = optional(any)
    source_image_id                  = optional(string)
    source_image_reference           = optional(any)
    admin_ssh_key                    = optional(any)
    identity                         = optional(any)
    plan                             = optional(any)
    network_interface_ids            = optional(list(string))
  }))
  default = {}
}

######
# azurerm_managed_disk
######

variable "data_disks" {
  description = "A list of the managed disk to associate to VMs. \n <a name=storage_account_type:></a>[storage_account_type:](#storage_account_type:) The type of storage to use for the managed disk. Possible values are Standard_LRS, StandardSSD_ZRS, Premium_LRS, Premium_ZRS, StandardSSD_LRS or UltraSSD_LRS. \n <a name=create_option:></a>[create_option:](#create_option:) The method to use when creating the managed disk. Changing this forces a new resource to be created. Possible values include: Import - Import a VHD file in to the managed disk (VHD specified with source_uri). Empty - Create an empty managed disk. Copy - Copy an existing managed disk or snapshot (specified with source_resource_id). FromImage - Copy a Platform Image (specified with image_reference_id) Restore - Set by Azure Backup or Site Recovery on a restored disk (specified with source_resource_id).  \n <a name=source_resource_id:></a>[source_resource_id:](#source_resource_id:) The ID of an existing Managed Disk to copy create_option is Copy or the recovery point to restore when create_option is Restore. \n <a name=disk_size_gb:></a>[disk_size_gb:](#disk_size_gb:) Specifies the size of the managed disk to create in gigabytes. If create_option is Copy or FromImage, then the value must be equal to or greater than the source's size. The size can only be increased. \n <a name=zone:></a>[zone:](#zone:) Specifies the Availability Zone in which this Managed Disk should be located. Changing this property forces a new resource to be created. \n <a name=disk_iops_read_write:></a>[disk_iops_read_write:](#disk_iops_read_write:) The number of IOPS allowed for this disk; only settable for UltraSSD disks. One operation can transfer between 4k and 256k bytes. \n <a name=disk_mbps_read_write:></a>[disk_mbps_read_write:](#disk_mbps_read_write:) The bandwidth allowed for this disk; only settable for UltraSSD disks. MBps means millions of bytes per second. \n <a name=disk_encryption_set_id:></a>[disk_encryption_set_id:](#disk_encryption_set_id:) The ID of a Disk Encryption Set which should be used to encrypt this Managed Disk. \n <a name=offset:></a>[offset:](#offset:) Number sufix in name of the disk. \n <a name=network_access_policy:></a>[network_access_policy:](#network_access_policy:) Policy for accessing the disk via network. Allowed values are AllowAll, AllowPrivate, and DenyAll. \n <a name=lun:></a>[lun:](#lun:) The Logical Unit Number of the Data Disk, which needs to be unique within the Virtual Machine. Changing this forces a new resource to be created. \n <a name=caching:></a>[caching:](#caching:) Specifies the caching requirements for this Data Disk. Possible values include None, ReadOnly and ReadWrite. \n <a name=write_accelerator_enabled:></a>[write_accelerator_enabled:](#write_accelerator_enabled:) Specifies if Write Accelerator is enabled on the disk. This can only be enabled on Premium_LRS managed disks with no caching and M-Series VMs. Defaults to false."
  type = map(object({
    storage_account_type      = optional(string)
    create_option             = optional(string)
    source_resource_id        = optional(string)
    disk_size_gb              = string
    zone                      = optional(string)
    disk_iops_read_write      = optional(string)
    disk_mbps_read_write      = optional(string)
    disk_encryption_set_id    = optional(string)
    offset                    = number
    lun                       = number
    network_access_policy     = optional(string)
    caching                   = optional(string)
    write_accelerator_enabled = optional(string)
  }))
  default = {}
}

######
# azurerm_network_interface
######

variable "nics" {
  description = "A list of network interfaces to associate to VMs. \n <a name=dns_servers:></a>[dns_servers:](#dns_servers:) A list of IP Addresses defining the DNS Servers which should be used for this Network Interface. \n <a name=enable_ip_forwarding:></a>[enable_ip_forwarding:](#enable_ip_forwarding:) Should IP Forwarding be enabled? Defaults to false. \n <a name=enable_accelerated_networking:></a>[enable_accelerated_networking:](#enable_accelerated_networking:) Should Accelerated Networking be enabled? Defaults to false. \n <a name=internal_dns_name_label:></a>[internal_dns_name_label:](#internal_dns_name_label:) The (relative) DNS Name used for internal communications between Virtual Machines in the same Virtual Network. \n <a name=ip_configurations:></a>[ip_configurations:](#ip_configurations:) The ip_configuration block supports the following: name - (Required) A name used for this IP Configuration. gateway_load_balancer_frontend_ip_configuration_id - (Optional) The Frontend IP Configuration ID of a Gateway SKU Load Balancer.subnet_id - (Optional) The ID of the Subnet where this Network Interface should be located in. \n <a name=offset:></a>[offset:](#offset:) Number sufix in name of the disk."
  type = map(object({
    dns_servers                   = optional(list(string))
    enable_ip_forwarding          = optional(string)
    enable_accelerated_networking = optional(string)
    internal_dns_name_label       = optional(string)
    ip_configurations             = any
    offset                        = number
  }))
  default = {}
}

######
# azurerm_backup_protected_vm
######

variable "backup_vm" {
  description = "Variable to create a Azure Backup for an Azure VM. \n <a name=name_vm:></a>[name_vm:](#name_vm:) Specifies the name of the VM to backup. Changing this forces a new resource to be created. \n <a name=recovery_vault_name:></a>[recovery_vault_name:](#recovery_vault_name:) Specifies the name of the Recovery Services Vault to use. Changing this forces a new resource to be created. \n <a name=backup_policy_id:></a>[backup_policy_id:](#backup_policy_id:) Specifies the id of the backup policy to use. \n <a name=exclude_disk_luns:></a>[exclude_disk_luns:](#exclude_disk_luns:) A list of Disks' Logical Unit Numbers(LUN) to be excluded for VM Protection. \n <a name=include_disk_luns:></a>[include_disk_luns:](#include_disk_luns:) A list of Disks' Logical Unit Numbers(LUN) to be included for VM Protection."
  type = map(object({
    name_vm             = string
    recovery_vault_name = string
    backup_policy_id    = string
    exclude_disk_luns   = optional(list(string))
    include_disk_luns   = optional(list(string))
  }))
  default = {}
}

######
# Tags
######

variable "tags" {
  description = "A mapping of labels to assign to all resources"
  type        = map(string)
}
