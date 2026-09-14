# "Generic Secret" - 3e2d3b2f-c22a-4df1-9cc6-a7a0aebb0c99  positive-test
resource "google_secret_manager_secret_version" "secret-version-basic2" {
  secret = "3gzcGokilvtw2HmCLuPx" # positive1

  secret_data = "secret-data"
}
