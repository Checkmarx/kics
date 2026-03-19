resource "google_redis_instance" "pass" {
  name           = "my-redis"
  memory_size_gb = 1
  region         = "us-central1"
  auth_enabled   = true
}
