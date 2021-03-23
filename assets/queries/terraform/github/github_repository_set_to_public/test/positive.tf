resource "github_repository" "positive1" {
  name        = "example"
  description = "My awesome codebase"

  template {
    owner = "github"
    repository = "terraform-module-template"
  }
}

resource "github_repository" "positive2" {
  name        = "example"
  description = "My awesome codebase"

  private = false

  template {
    owner = "github"
    repository = "terraform-module-template"
  }
}

resource "github_repository" "positive3" {
  name        = "example"
  description = "My awesome codebase"

  private = true
  visibility = "public"

  template {
    owner = "github"
    repository = "terraform-module-template"
  }
}
