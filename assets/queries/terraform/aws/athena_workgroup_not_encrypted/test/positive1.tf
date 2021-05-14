resource "aws_athena_workgroup" "example" {
  name = "example"
}

resource "aws_athena_workgroup" "example_2" {
  name = "example"

  configuration {
    enforce_workgroup_configuration    = true
    publish_cloudwatch_metrics_enabled = true
  }
}

resource "aws_athena_workgroup" "example_3" {
  name = "example"

  configuration {
    enforce_workgroup_configuration    = true
    publish_cloudwatch_metrics_enabled = true

    result_configuration {
      output_location = "s3://${aws_s3_bucket.example.bucket}/output/"
    }
  }
}
