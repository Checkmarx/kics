
resource "azurerm_linux_virtual_machine" "vms" {
  for_each = var.linux_vms

  name                  = "${local.prefix}${each.key}"
  location              = try(each.value.region, "West Europe") != null ? each.value.region : "West Europe"
  resource_group_name   = var.resource_group_name
  size                  = try(each.value.size, "Standard_F2") != null ? each.value.size : "Standard_F2"
  admin_username        = try(each.value.admin_username, "monitor") != null ? each.value.admin_username : "monitor"
  admin_password        = try(each.value.admin_password, null)
  license_type          = try(each.value.license_type, null)
  network_interface_ids = each.value.network_interface_ids == null ? tolist([azurerm_network_interface.nics[each.key].id]) : each.value.network_interface_ids

  dynamic "additional_capabilities" {
    for_each = try(each.value.ultra_ssd_enabled, null) == true ? [1] : []

    content {
      ultra_ssd_enabled = true
    }
  }

  dynamic "boot_diagnostics" {
    for_each = try(each.value.boot_diagnostics_storage_account, null) == null ? [] : [1]

    content {
      storage_account_uri = each.value.boot_diagnostics_storage_account
    }
  }

  allow_extension_operations      = try(each.value.allow_extension_operations, null)
  availability_set_id             = try(each.value.availability_set_id, null)
  computer_name                   = try(each.value.computer_name, null)
  custom_data                     = try(each.value.custom_data, null) != null ? filebase64("${path.cwd}/${each.value.custom_data}") : each.value.custom_data_txt != null ? base64encode(each.value.custom_data_txt) : null
  dedicated_host_id               = try(each.value.dedicated_host_id, null)
  encryption_at_host_enabled      = try(each.value.encryption_at_host_enabled, null)
  eviction_policy                 = try(each.value.eviction_policy, null)
  extensions_time_budget          = try(each.value.extensions_time_budget, null)
  max_bid_price                   = try(each.value.max_bid_price, null)
  platform_fault_domain           = try(each.value.platform_fault_domain, null)
  priority                        = try(each.value.priority, null)
  provision_vm_agent              = try(each.value.provision_vm_agent, true)
  proximity_placement_group_id    = try(each.value.proximity_placement_group_id, null)
  zone                            = try(each.value.zone, null)
  disable_password_authentication = try(each.value.disable_password_authentication, true)
  virtual_machine_scale_set_id    = try(each.value.virtual_machine_scale_set_id, null)

  os_disk {
    caching                   = try(each.value.os_disk.caching, "None")
    disk_size_gb              = try(each.value.os_disk.disk_size_gb, null)
    name                      = "${local.prefix}${each.key}-osdisk01-${var.tags.environment}"
    storage_account_type      = try(each.value.os_disk.storage_account_type, "Standard_LRS")
    write_accelerator_enabled = try(each.value.os_disk.write_accelerator_enabled, false)
    disk_encryption_set_id    = try(each.value.os_disk.disk_encryption_set_key, null)
  }

  dynamic "admin_ssh_key" {
    for_each = try(each.value.admin_ssh_key, {}) == null ? [] : each.value.admin_ssh_key

    content {
      username   = admin_ssh_key.value.username
      public_key = admin_ssh_key.value.public_key
    }
  }

  dynamic "identity" {
    for_each = try(each.value.identity, {}) == null ? [] : each.value.identity

    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  source_image_id = try(each.value.source_image_id, null) != null ? each.value.source_image_id : null

  dynamic "source_image_reference" {
    for_each = try(each.value.source_image_reference, {}) == null ? [] : each.value.source_image_reference

    content {
      publisher = source_image_reference.value.publisher
      offer     = source_image_reference.value.offer
      sku       = source_image_reference.value.sku
      version   = source_image_reference.value.version
    }
  }

  dynamic "plan" {
    for_each = try(each.value.plan, {}) == null ? [] : each.value.plan

    content {
      name      = plan.value.name
      product   = plan.value.product
      publisher = plan.value.publisher
    }
  }

  tags = merge(
    var.tags,
    {
      "resource_name"   = "${local.prefix}${each.key}",
      "resource_type"   = "vm",
      "deployment_date" = formatdate("DD-MM-YYYY", timestamp()),
    }
  )

  lifecycle {
    ignore_changes = [
      # Ignore changes to tags, e.g. because a management agent
      # updates these based on some ruleset managed elsewhere.
      tags["status"],
      tags["on_service"],
    ]
  }
}

resource "azurerm_backup_protected_vm" "vm" {
  for_each = var.backup_vm

  resource_group_name = var.resource_group_name
  recovery_vault_name = each.value.recovery_vault_name
  source_vm_id        = azurerm_linux_virtual_machine.vms[each.value.name_vm].id
  backup_policy_id    = each.value.backup_policy_id
  exclude_disk_luns   = each.value.exclude_disk_luns
  include_disk_luns   = each.value.include_disk_luns
}
