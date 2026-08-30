resource "ibm_is_instance" "vsi_no_boot_block" {
  name    = "vsi-default"
  image   = "r006-12345678"
  profile = "bx2-2x8"
  vpc     = "vpc-id"
  zone    = "us-south-1"
  keys    = ["key-id"]
}