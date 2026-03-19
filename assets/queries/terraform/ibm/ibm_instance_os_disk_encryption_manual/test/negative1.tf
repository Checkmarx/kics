resource "ibm_is_instance" "vsi_secure" {
  name    = "vsi-secure"
  image   = "r006-12345678"
  profile = "bx2-2x8"

  boot_volume {
    name       = "boot-disk-cmk"
    encryption = "crn:v1:bluemix:public:kms:us-south:a/test:test:key:test"
  }
}