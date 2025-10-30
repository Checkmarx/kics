terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = "your-project-id"
  region  = "us-central1"
}

resource "google_storage_bucket" "sample_bucket" {
  name                        = "my-random-sample-bucket-${random_id.bucket_id.hex}"
  location                    = "EU"
  force_destroy               = true
  versioning {
    enabled = true
  }
}

resource "random_id" "bucket_id" {
  byte_length = 4
}

# No "google_project_service" resource set
