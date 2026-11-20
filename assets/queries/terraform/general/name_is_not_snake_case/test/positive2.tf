# These SHOULD be flagged - non-snake_case user-defined resources

resource "aws_instance" "MyWebServer" {
  ami           = "ami-12345"
  instance_type = "t2.micro"
}

resource "aws_s3_bucket" "applicationDataBucket" {
  bucket = "my-app-data"
}

resource "aws_lambda_function" "ProcessUserEvents" {
  function_name = "process-user-events"
  runtime       = "nodejs14.x"
}

resource "google_compute_instance" "webServer-01" {
  name         = "web-server"
  machine_type = "e2-micro"
}

# Long names that should use snake_case
resource "aws_iam_role" "VeryLongApplicationServiceRole" {
  name = "application-service-role"
}

resource "azurerm_virtual_machine" "ProductionWebServerInstance" {
  name = "prod-web-server"
}
