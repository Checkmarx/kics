// comment
resource "github_repository" "example" {
  name        = "example"
  description = "My awesome codebase"

  private = true
  visibility = "private"

  template {
    owner = "github"
    repository = "terraform-module-template"
  }
}