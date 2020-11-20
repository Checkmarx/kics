#this code is a correct code for which the query should not find any result
resource "github_repository" "example" {
  name        = "example"
  description = "My awesome codebase"

  private = true

  template {
    owner = "github"
    repository = "terraform-module-template"
  }
}