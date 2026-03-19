resource "ibm_is_instance" "vsi_no_encryption" {
  name    = "vsi-unprotected-boot"
  image   = "r006-12345678"
  profile = "bx2-2x8"
  
  boot_volume {
    name = "boot-disk-standard"
    # FALLO: Falta atributo encryption
  }
}