# These variables SHOULD be flagged - complex types without descriptions
variable "complex_configuration" {
  type = object({
    database = object({
      host     = string
      port     = number
      username = string
      password = string
    })
    cache = object({
      enabled = bool
      ttl     = number
    })
  })
}

variable "service_endpoints" {
  type = map(object({
    url    = string
    port   = number
    secure = bool
  }))
}

variable "deployment_stages" {
  type = list(object({
    name        = string
    environment = string
    replicas    = number
  }))
}

# Sensitive variable without description
variable "database_password" {
  type      = string
  sensitive = true
}

# Variable with validation rules
variable "instance_size" {
  type = string
  validation {
    condition     = can(regex("^(small|medium|large)$", var.instance_size))
    error_message = "Instance size must be small, medium, or large."
  }
}

# Long, non-obvious variable name
variable "custom_application_load_balancer_configuration_settings" {
  type = string
}
