# Complex variables that should be flagged for missing descriptions

# Complex object type without description
variable "database_config" {
  type = object({
    engine         = string
    engine_version = string
    instance_class = string
    allocated_storage = number
    backup_retention_period = number
    multi_az = bool
  })
}

# Variable with validation rules but no description
variable "instance_size" {
  type = string
  validation {
    condition = contains(["small", "medium", "large"], var.instance_size)
    error_message = "Instance size must be small, medium, or large."
  }
}

# Sensitive variable without description
variable "database_password" {
  type = string
  sensitive = true
}

# Complex variable name without default and no description
variable "advanced_networking_configuration_settings" {
  type = map(string)
}

# Map of objects without description
variable "service_configs" {
  type = map(object({
    port = number
    protocol = string
    health_check_path = string
  }))
}

# Set of complex objects without description
variable "security_group_rules" {
  type = set(object({
    type        = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}
