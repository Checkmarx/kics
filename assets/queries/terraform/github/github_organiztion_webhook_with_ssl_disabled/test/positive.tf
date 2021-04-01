resource "github_organization_webhook" "positive1" {
  name = "web"

  configuration {
    url          = "https://google.de/"
    content_type = "form"
    insecure_ssl = true
  }

  active = false

  events = ["issues"]
}