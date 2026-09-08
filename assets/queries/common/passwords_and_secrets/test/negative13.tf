# "Generic API Key" - 74736dd1-dd11-4139-beb6-41cd43a50317  negative-test ('.' char is illegal in key definition, incorrect key length (17 is not in {32,45}))
provider "stripe" {
  api_key = var.strip_api_key
}
