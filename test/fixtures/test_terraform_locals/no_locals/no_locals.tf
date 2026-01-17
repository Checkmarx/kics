variable "test_var" {
  type    = string
  default = "test"
}

resource "terraform_data" "no_locals" {
  name = var.test_var
}

