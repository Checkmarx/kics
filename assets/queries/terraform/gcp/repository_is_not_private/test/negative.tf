// comment
resource "github_repository" "example" {
  name        = "example"
  description = "My awesome codebase"

  private = false

  template {
    owner = "github"
    repository = "terraform-module-template"
  }
}