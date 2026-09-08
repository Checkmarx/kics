# Global allow rule  - a88baa34-e2ad-44ea-ad6f-8cac87bc7c71 - "Avoiding TF file function"  allow-rule-test
data "terraform_remote_state" "intnet" {
  backend = "azurerm"
  config = {
    storage_account_name = "asdsadas"
    container_name       = "dp-prasdasdase-001"
    key                  = "infrastructure.tfstate"
    access_key           = file(var.access_key_path)  # negative1
  }
  workspace = terraform.workspace
}
