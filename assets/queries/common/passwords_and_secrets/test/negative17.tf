provider "cloudflare" {
  version = "~> 2.0"
  email   = "var.cloudflare_email"
  api_key = "var.api_key"
}
