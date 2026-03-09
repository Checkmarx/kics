resource "google_redis_instance" "pass" {
  name                    = "my-redis"
  memory_size_gb          = 1
  region                  = "us-central1"
  transit_encryption_mode = "SERVER_AUTHENTICATION"
}
