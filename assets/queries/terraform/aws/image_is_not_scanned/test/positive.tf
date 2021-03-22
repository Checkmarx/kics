resource "aws_ecr_repository" "positive1" {
  name                 = "img_p_2"
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_repository" "positive2" {
  name                 = "img_p_1"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}