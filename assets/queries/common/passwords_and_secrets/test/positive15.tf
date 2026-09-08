# "AWS Access Key" - 76c0bcde-903d-456e-ac13-e58c34987852  positive-test (line 16)
# "AWS Secret Key" - 83ab47ff-381d-48cd-bac5-fb32222f54af  positive-test (line 17)
resource "aws_instance" "web_host" {
  # ec2 have plain text secrets in user data
  ami           = var.ami
  instance_type = "t2.nano"

  vpc_security_group_ids = ["aws_security_group.web-node.id"]
  subnet_id = aws_subnet.web_subnet.id
  user_data = <<EOF
#! /bin/bash
sudo apt-get update
sudo apt-get install -y apache2
sudo systemctl start apache2
sudo systemctl enable apache2
export AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMAAA
export AWS_SECRET_ACCESS_KEY=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
export AWS_DEFAULT_REGION=us-west-2
echo "<h1>Deployed via Terraform</h1>" | sudo tee /var/www/html/index.html
EOF
  tags = merge({
    Name = "${local.resource_prefix.value}-ec2"
    }, {
    git_last_modified_by = "email@email.com"
    git_modifiers        = "foo.bar"
    git_org              = "checkmarx"
    git_repo             = "kics"
  })
}
