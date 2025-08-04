
locals {
  prefix = join("-", tolist(["go", lower(var.tags.region), var.tags.enterprise, var.tags.account, var.tags.system, ""]))

  iam_user = compact([
    for k, v in var.iam != null ? var.iam : {} :
    v.type == "CLOUD_IAM_USER" ? v.name : ""
  ])

  # iam_group = compact([
  #   for k, v in var.iam != null ? var.iam : {} :
  #   v.type == "CLOUD_IAM_GROUP" ? v.name : ""
  # ])

  iam_sa = compact([
    for k, v in var.iam != null ? var.iam : {} :
    v.type == "CLOUD_IAM_SERVICE_ACCOUNT" ? v.name : ""
  ])
}

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

        dynamic "psc_config" {
          for_each = var.ip_configuration.psc_config == null ? [] : [true]
          content {
            psc_enabled               = var.ip_configuration.psc_config.psc_enabled
            allowed_consumer_projects = var.ip_configuration.psc_config.allowed_consumer_projects
          }
        }
        
    dynamic "advanced_machine_features" {
      for_each = var.threads_per_core == null ? [] : [true]
      content {
        threads_per_core = var.threads_per_core
      }
    }

    dynamic "database_flags" {
      for_each = var.database_flags == null ? {} : var.database_flags
      content {
        name  = database_flags.value.name
        value = database_flags.value.value
      }
    }

    dynamic "deny_maintenance_period" {
      for_each = var.deny_maintenance_period == null ? [] : [true]
      content {
        end_date   = var.deny_maintenance_period.end_date
        start_date = var.deny_maintenance_period.start_date
        time       = var.deny_maintenance_period.time
      }
    }

    dynamic "sql_server_audit_config" {
      for_each = var.sql_server_audit_config == null ? [] : [true]
      content {
        bucket             = var.sql_server_audit_config.bucket
        upload_interval    = var.sql_server_audit_config.upload_interval
        retention_interval = var.sql_server_audit_config.retention_interval
      }
    }

    dynamic "backup_configuration" {
      for_each = var.backup_configuration == null ? [] : [true]
      content {
        binary_log_enabled             = var.backup_configuration.binary_log_enabled
        enabled                        = var.backup_configuration.enabled
        start_time                     = var.backup_configuration.start_time
        point_in_time_recovery_enabled = var.backup_configuration.point_in_time_recovery_enabled
        location                       = var.backup_configuration.location
        transaction_log_retention_days = var.backup_configuration.transaction_log_retention_days

        dynamic "backup_retention_settings" {
          for_each = var.backup_configuration.backup_retention_settings == null ? [] : [true]
          content {
            retained_backups = var.backup_configuration.backup_retention_settings.retained_backups
            retention_unit   = var.backup_configuration.backup_retention_settings.retention_unit
          }
        }
      }
    }


        dynamic "authorized_networks" {
          for_each = var.ip_configuration.authorized_networks == null ? {} : var.ip_configuration.authorized_networks
          content {
            expiration_time = authorized_networks.value.expiration_time
            name            = authorized_networks.value.name
            value           = authorized_networks.value.value
          }
        }
      }
    }

    dynamic "location_preference" {
      for_each = var.location_preference == null ? [] : [true]
      content {
        follow_gae_application = var.location_preference.follow_gae_application
        zone                   = var.location_preference.zone
        secondary_zone         = var.location_preference.secondary_zone
      }
    }

    dynamic "maintenance_window" {
      for_each = var.maintenance_window == null ? [] : [true]
      content {
        day          = var.maintenance_window.day
        hour         = var.maintenance_window.hour
        update_track = var.maintenance_window.update_track
      }
    }

    dynamic "insights_config" {
      for_each = var.insights_config == null ? [] : [true]
      content {
        query_insights_enabled  = var.insights_config.query_insights_enabled
        query_string_length     = var.insights_config.query_string_length
        record_application_tags = var.insights_config.record_application_tags
        record_client_address   = var.insights_config.record_client_address
        query_plans_per_minute  = var.insights_config.query_plans_per_minute
      }
    }

    dynamic "password_validation_policy" {
      for_each = var.password_validation_policy == null ? [] : [true]
      content {
        min_length                  = var.password_validation_policy.min_length
        complexity                  = var.password_validation_policy.complexity
        reuse_interval              = var.password_validation_policy.reuse_interval
        disallow_username_substring = var.password_validation_policy.disallow_username_substring
        password_change_interval    = var.password_validation_policy.password_change_interval
        enable_password_policy      = var.password_validation_policy.enable_password_policy
      }
    }
  }

  dynamic "replica_configuration" {
    for_each = var.replica_configuration == null ? [] : [true]
    content {
      ca_certificate            = var.replica_configuration.ca_certificate
      client_certificate        = var.replica_configuration.client_certificate
      client_key                = var.replica_configuration.client_key
      connect_retry_interval    = var.replica_configuration.connect_retry_interval
      dump_file_path            = var.replica_configuration.dump_file_path
      failover_target           = var.replica_configuration.failover_target
      master_heartbeat_period   = var.replica_configuration.master_heartbeat_period
      password                  = var.replica_configuration.password
      ssl_cipher                = var.replica_configuration.sslCipher
      username                  = var.replica_configuration.username
      verify_server_certificate = var.replica_configuration.verify_server_certificate
    }
  }

  dynamic "clone" {
    for_each = var.clone == null ? [] : [true]
    content {
      source_instance_name = var.clone.source_instance_name
      point_in_time        = var.clone.point_in_time
      database_names       = var.clone.database_names
      allocated_ip_range   = var.clone.allocated_ip_range
    }
  }

  dynamic "restore_backup_context" {
    for_each = var.restore_backup_context == null ? [] : [true]
    content {
      backup_run_id = var.restore_backup_context.backup_run_id
      instance_id   = var.restore_backup_context.instance_id
      project       = var.restore_backup_context.project
    }
  }
}

resource "google_sql_database" "databases" {
  for_each = var.additional_databases

  name            = format("${local.prefix}${each.value.name}-db%.2d-${var.tags.environment}", each.value.offset)
  instance        = google_sql_database_instance.database_instance.name
  charset         = each.value.charset
  collation       = each.value.collation
  project         = var.project_id
  deletion_policy = each.value.deletion_policy
}

resource "google_sql_user" "iam_user" {
  for_each = toset(local.iam_user)
  project  = var.project_id
  name     = each.value
  instance = google_sql_database_instance.database_instance.name
  type     = "CLOUD_IAM_USER"
}

# add in version 5.0
# resource "google_sql_user" "iam_group_user" {
#   for_each = local.iam_group
#   name     = each.value
#   instance = google_sql_database_instance.database_instance.name
#   type     = "CLOUD_IAM_GROUP"
# }

resource "google_sql_user" "iam_service_account_user" {
  for_each = toset(local.iam_sa)
  project  = var.project_id
  name     = length(split("POSTGRES", var.database_version)) == 2 ? trimsuffix(each.value, ".gserviceaccount.com") : each.value
  instance = google_sql_database_instance.database_instance.name
  type     = "CLOUD_IAM_SERVICE_ACCOUNT"
}
