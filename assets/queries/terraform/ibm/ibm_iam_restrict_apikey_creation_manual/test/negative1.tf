# El cumplimiento es "negativo" cuando no hay políticas de IAM que auditar en este contexto.
resource "ibm_is_vpc" "example_vpc" {
  name = "compliant-network"
}