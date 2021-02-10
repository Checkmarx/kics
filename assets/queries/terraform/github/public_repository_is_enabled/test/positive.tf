resource "github_repository" "example1" {
  name        = "example"
  description = "My awesome codebase"

  template {
    owner = "github"
    repository = "terraform-module-template"
  }
}

resource "github_repository" "example2" {
  name        = "example"
  description = "My awesome codebase"

  private = false

  template {
    owner = "github"
    repository = "terraform-module-template"
  }
}

resource "github_repository" "example3" {
  name        = "example"
  description = "My awesome codebase"

  private = true
  visibility = "public"

  template {
    owner = "github"
    repository = "terraform-module-template"
  }
}
