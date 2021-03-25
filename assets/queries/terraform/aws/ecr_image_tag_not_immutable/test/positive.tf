resource "aws_ecr_repository" "foo2" {
  name                 = "bar"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "foo3" {
  name                 = "bar"

  image_scanning_configuration {
    scan_on_push = true
  }
}
