


resource "google_sql_database_instance" "database_instance" {

  provider             = google-beta
  project              = var.project_id
  name                 = format("${local.prefix}${var.name}-cloudsql%.2d-${var.tags.environment}", var.offset)
  database_version     = var.database_version
  region               = var.region
  maintenance_version  = var.maintenance_version
  master_instance_name = var.master_instance_name
  root_password        = var.root_password
  encryption_key_name  = var.encryption_key_name
  deletion_protection  = var.deletion_protection

  settings {
    tier                        = var.tier
    activation_policy           = var.activation_policy
    availability_type           = var.availability_type
    collation                   = var.db_collation
    connector_enforcement       = var.connector_enforcement
    deletion_protection_enabled = var.deletion_protection_enabled
    disk_autoresize             = var.disk_autoresize
    disk_autoresize_limit       = var.disk_autoresize_limit
    disk_size                   = var.disk_size
    disk_type                   = var.disk_type
    pricing_plan                = var.pricing_plan
    time_zone                   = var.time_zone
    user_labels                 = var.tags


      dynamic "ip_configuration" {
        for_each = var.ip_configuration == null ? [] : [true]
        content {
          ipv4_enabled                                  = var.ip_configuration.ipv4_enabled
          private_network                               = var.ip_configuration.private_network
          ssl_mode                                      = var.ip_configuration.ssl_mode
          allocated_ip_range                            = var.ip_configuration.allocated_ip_range
          enable_private_path_for_google_cloud_services = var.ip_configuration.enable_private_path_for_google_cloud_services
        }
      }
  }
}
