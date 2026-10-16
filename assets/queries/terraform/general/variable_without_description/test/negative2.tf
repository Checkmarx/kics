# Cases that should NOT be flagged by the improved rule

# Self-explanatory variable names
variable "region" {
  type = string
  default = "us-west-2"
}

variable "environment" {
  type = string
  default = "dev"
}

variable "port" {
  type = number
  default = 8080
}

variable "enabled" {
  type = bool
  default = true
}

# Variables with obvious suffixes
variable "instance_count" {
  type = number
  default = 3
}

variable "database_name" {
  type = string
  default = "myapp"
}

variable "api_key" {
  type = string
  sensitive = false  # Not sensitive, so description not required
}

# Variables with obvious prefixes
variable "enable_logging" {
  type = bool
  default = true
}

variable "is_production" {
  type = bool
  default = false
}

variable "use_ssl" {
  type = bool
  default = true
}

# Simple variables with defaults and simple types
variable "app" {
  type = string
  default = "webapp"
}

variable "tier" {
  type = string
  default = "web"
}

variable "zone" {
  type = string
  default = "a"
}
