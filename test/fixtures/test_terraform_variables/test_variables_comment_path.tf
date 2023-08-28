// kics_terraform_vars: varsToUse\\varsToUse.tf

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