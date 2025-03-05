variable "config_acr" {
	type = object({
    admin_password_name = string
  })
	description = "ACR where the APM Server configuration container is located"
}

variable "config_acr" {
	type = object({admin_password = optional(string), admin_password_key_vault_secret_id = optional(string)})
	description = "ACR where the APM Server configuration container is located"
}

variable "config_acr" {
	type = object({admin_password = string, admin_password_key_vault_secret_id = string})
	description = "ACR where the APM Server configuration container is located"
}
