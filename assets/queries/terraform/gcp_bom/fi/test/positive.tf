resource "google_filestore_instance" "instance" {
  name = "test-instance"
  location = "us-central1-b"
  tier = "BASIC_SSD"

  file_shares {
    capacity_gb = 2660
    name        = "share1"

    nfs_export_options {
      ip_ranges = ["10.0.0.0/24"]
      access_mode = "READ_WRITE"
      squash_mode = "NO_ROOT_SQUASH"
   }

   nfs_export_options {
      ip_ranges = ["10.10.0.0/24"]
      access_mode = "READ_ONLY"
      squash_mode = "ROOT_SQUASH"
      anon_uid = 123
      anon_gid = 456
   }
  }

  networks {
    network = "default"
    modes   = ["MODE_IPV4"]
    connect_mode = "DIRECT_PEERING"
  }
}

resource "google_filestore_instance" "instance2" {
  name = "test-instance"
  location = "us-central1"
  tier = "ENTERPRISE"

  file_shares {
    capacity_gb = 2560
    name        = "share1"
  }

  networks {
    network = "default"
    modes   = ["MODE_IPV4"]
  }
  kms_key_name = google_kms_crypto_key.filestore_key.id
}

resource "google_kms_key_ring" "filestore_keyring" {
  name     = "filestore-keyring"
  location = "us-central1"
}

resource "google_kms_crypto_key" "filestore_key" {
  name            = "filestore-key"
  key_ring        = google_kms_key_ring.filestore_keyring.id
}

resource "google_filestore_instance" "instance3" {
  name = "test-instance"
  location = "us-central1-b"
  tier = "BASIC_SSD"

  file_shares {
    capacity_gb = 2660
    name        = "share1"

    nfs_export_options {
      ip_ranges = ["0.0.0.0/0"]
      access_mode = "READ_WRITE"
      squash_mode = "NO_ROOT_SQUASH"
   }
  }

  networks {
    network = "default"
    modes   = ["MODE_IPV4"]
    connect_mode = "DIRECT_PEERING"
  }
}
