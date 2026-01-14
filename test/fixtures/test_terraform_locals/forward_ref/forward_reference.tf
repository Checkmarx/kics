locals {
  # This references 'backend_name' which is defined later in the same block
  full_backend = "${local.backend_name}-production"
  backend_name = "api"
  
  # This references 'db_port' which is defined later
  connection_string = "localhost:${local.db_port}"
  db_port           = 5432
}

resource "test" "forward_ref" {
  backend = local.full_backend
  connection = local.connection_string
}

