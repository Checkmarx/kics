provider "oci" {
  region = "us-ashburn-1"
}

resource "oci_identity_policy" "unsafe_volume_admin" {
  name           = "UnsafeVolumeAdmin"
  compartment_id = "ocid1.tenancy..."

  # FALLO: Otorga manage (incluye delete) en volume-family
  statements = [
    "Allow group BackupAdmins to MANAGE volume-family in tenancy"
  ]
}