data "terraform_remote_state" "intnet" {
  backend = "azurerm"
  config = {
    storage_account_name = "asdsadas"
    container_name       = "dp-prasdasdase-001"
    key                  = "infrastructure.tfstate"
    access_key           = file(var.access_key_path)
  }
  workspace = terraform.workspace
}
