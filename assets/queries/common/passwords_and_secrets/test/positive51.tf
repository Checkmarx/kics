variable "config_acr" {
	type = object({
		admin_password = optional(string, "password")
		admin_password_key_vault_secret_id = optional(string)
	})
	description = "ACR where the APM Server configuration container is located"
}

variable "config_acr" {
	type = object({admin_password = optional(string), admin_password_key_vault_secret_id = optional(string, "password")})
	description = "ACR where the APM Server configuration container is located"
}
