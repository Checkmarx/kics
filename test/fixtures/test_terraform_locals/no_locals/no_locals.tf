variable "test_var" {
  type    = string
  default = "test"
}

resource "test" "no_locals" {
  name = var.test_var
}

