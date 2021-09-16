resource "google_secret_manager_secret_version" "secret-version-basic2" {
  secret = "3gzcGokilvtw2HmCLuPx"

  secret_data = "secret-data"
}
