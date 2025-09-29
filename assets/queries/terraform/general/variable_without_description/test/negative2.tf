# These variables should NOT be flagged - self-explanatory names
variable "region" {
  type    = string
  default = "us-east-1"
}

variable "environment" {
  type    = string
  default = "prod"
}

variable "vpc_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "port" {
  type    = number
  default = 80
}

variable "enabled" {
  type    = bool
  default = true
}

# Short and simple variables
variable "name" {
  type = string
}

variable "key" {
  type = string
}

variable "tags" {
  type = map(string)
  default = {}
}

# Variables with clear prefixes/suffixes
variable "enable_monitoring" {
  type    = bool
  default = false
}

variable "is_production" {
  type    = bool
  default = false
}

variable "instance_count" {
  type    = number
  default = 1
}

variable "database_name" {
  type = string
}

# Single word variables under 12 chars
variable "version" {
  type    = string
  default = "1.0"
}
