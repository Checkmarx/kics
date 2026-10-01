# "Generic API Key" - 74736dd1-dd11-4139-beb6-41cd43a50317  negative-test ('.' char is illegal in key definition, incorrect key length (11 is not in {32,45}))
provider "cloudflare" {
  version = "~> 2.0"
  email   = "var.cloudflare_email"
  api_key = "var.api_key"
}
