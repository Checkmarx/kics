# El cumplimiento es "negativo" cuando no hay recursos de claves de API que requieran monitoreo de ciclo de vida.
resource "ibm_is_vpc" "safe_vpc" {
  name = "compliant-vpc"
}

resource "ibm_iam_access_group" "acc_group" {
  name = "test-group"
}