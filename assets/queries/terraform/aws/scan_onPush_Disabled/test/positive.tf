resource "aws_ecr_repository" "positive_2" {
  name                 = "img_p_2"
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_repository" "positive_1" {
  name                 = "img_p_1"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}