variable "local_default_var" {
  type    = "string"
  default = "local_default"
}

variable "" {
  type    = "string"
  default = "invalid_block"
}

variable "invalid_attr" {
}

resource "test" "test1" {
  test_map        = var.map2
  test_bool       = var.test1
  test_list       = var.test2
  test_neted_map  = var.map2[var.map1["map1key1"]]

  test_block {
    terraform_var = var.test_terraform
  }

  test_default_local = var.local_default_var
  test_default       = var.default_var
}
