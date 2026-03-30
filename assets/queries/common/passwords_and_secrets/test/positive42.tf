# "Generic Access Key" - 7f370dd5-eea3-4e5f-8354-3cb2506f9f13  positive-test
data "terraform_remote_state" "intnet" {
  backend = "azurerm"
  config = {
    storage_account_name = "asdsadas"
    container_name       = "dp-prasdasdase-001"
    key                  = "infrastructure.tfstate"
    access_key           = "sdsaljasbdasddsadsa"  # positive1
  }
  workspace = terraform.workspace
}
