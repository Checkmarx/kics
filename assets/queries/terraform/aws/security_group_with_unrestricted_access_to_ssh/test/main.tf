

#IAM Role
resource "aws_iam_role" "web-app-instance-role" {
  assume_role_policy = <<POLICY
{
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      }
    }
  ],
  "Version": "2012-10-17"
}
POLICY

  description          = "Allows EC2 instances to call AWS services on your behalf."
  max_session_duration = "3600"
  name                 = "web-app-role"
  path                 = "/"

  tags = {
    name = "demo-instance-1"
  }
}

resource "aws_iam_role" "privileged-instance-role" {
  assume_role_policy = <<POLICY
{
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      }
    }
  ],
  "Version": "2012-10-17"
}
POLICY

  description          = "Allows EC2 instances to call AWS services on your behalf."
  max_session_duration = "3600"
  name                 = "admin-role-1018"
  path                 = "/"

  tags = {
    name = "demo-instance-2"
  }
}

#IAM Role policy
resource "aws_iam_policy" "web-app-instance-policy" {
  name        = "web-instance-policy"
  description = "Provides full access to Amazon EC2 via the AWS Management Console"
  policy      = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": ["ec2:*"],
            "Effect": "Allow",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": ["elasticloadbalancing:*"],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": ["cloudwatch:*"],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
              "iam:*"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "iam:CreateServiceLinkedRole",
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "iam:AWSServiceName": [
                        "autoscaling.amazonaws.com",
                        "ec2scheduled.amazonaws.com",
                        "elasticloadbalancing.amazonaws.com",
                        "spot.amazonaws.com",
                        "spotfleet.amazonaws.com",
                        "transitgateway.amazonaws.com"
                    ]
                }
            }
        }
    ]
}
POLICY
}

resource "aws_iam_policy" "privileged-instance-policy" {
  name        = "privileged-instance-policy"
  description = "Provides full access to AWS services and resources."
  policy      = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
        "*"
      ],
            "Resource": "*"
        }
    ]
}
POLICY
}

#IAM Role Policy Attachment
resource "aws_iam_role_policy_attachment" "privileged-instance-attachment" {
  policy_arn = aws_iam_policy.privileged-instance-policy.arn
  role       = aws_iam_role.privileged-instance-role.name
}

resource "aws_iam_role_policy_attachment" "web-app-instance-attachment" {
  policy_arn = aws_iam_policy.web-app-instance-policy.arn
  role       = aws_iam_role.web-app-instance-role.name
}

#IAM Instance Profile
resource "aws_iam_instance_profile" "web-app-instance-profile" {
  name = "web-app-instance-profile"
  path = "/"
  role = aws_iam_role.web-app-instance-role.name
}

resource "aws_iam_instance_profile" "privileged-instance-profile" {
  name = "privileged-instance-profile"
  path = "/"
  role = aws_iam_role.privileged-instance-role.name
}

resource "aws_vpc" "demo-vpc" {
  assign_generated_ipv6_cidr_block = "false"
  cidr_block                       = "10.10.0.0/16"
  enable_classiclink               = "false"
  enable_classiclink_dns_support   = "false"
  enable_dns_hostnames             = "true"
  enable_dns_support               = "true"
  instance_tenancy                 = "default"

  tags = {
    Name = "demo-vpc"
  }
}

#internet gateway
resource "aws_internet_gateway" "demo-igw" {
  tags = {
    Name = "demo-igw"
  }

  vpc_id = aws_vpc.demo-vpc.id
}

#subnet
resource "aws_subnet" "subnet-1" {
  assign_ipv6_address_on_creation = "false"
  cidr_block                      = "10.10.10.0/24"
  map_public_ip_on_launch         = "false"

  tags = {
    Name = "public-subnet-01"
  }

  vpc_id = aws_vpc.demo-vpc.id
}

resource "aws_subnet" "subnet-2" {
  assign_ipv6_address_on_creation = "false"
  cidr_block                      = "10.10.20.0/24"
  map_public_ip_on_launch         = "false"

  tags = {
    Name = "public-subnet-02"
  }

  vpc_id = aws_vpc.demo-vpc.id
}

#route table
resource "aws_route_table" "demo-route-table" {
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo-igw.id
  }

  tags = {
    Name = "acc-test-route-table"
  }

  vpc_id = aws_vpc.demo-vpc.id
}

#route table association
resource "aws_route_table_association" "subnet-1-association" {
  route_table_id = aws_route_table.demo-route-table.id
  subnet_id      = aws_subnet.subnet-1.id
}

resource "aws_route_table_association" "subnet-2-association" {
  route_table_id = aws_route_table.demo-route-table.id
  subnet_id      = aws_subnet.subnet-2.id
}

#Security Groups
resource "aws_security_group" "web-app-security-group" {
  description = "Allow SSH connection"

  egress {
    cidr_blocks      = ["0.0.0.0/0"]
    from_port        = 0
    ipv6_cidr_blocks = ["::/0"]
    protocol         = "-1"
    self             = "false"
    to_port          = 0
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "tcp"
    self        = "false"
    to_port     = 65535
  }

  ingress {
    cidr_blocks      = ["0.0.0.0/0"]
    from_port        = 22
    ipv6_cidr_blocks = ["::/0"]
    protocol         = "tcp"
    self             = "false"
    to_port          = 22
  }

  ingress {
    cidr_blocks      = ["0.0.0.0/0"]
    from_port        = 80
    ipv6_cidr_blocks = ["::/0"]
    protocol         = "tcp"
    self             = "false"
    to_port          = 80
  }

  ingress {
    cidr_blocks      = ["0.0.0.0/0"]
    from_port        = 8080
    ipv6_cidr_blocks = ["::/0"]
    protocol         = "tcp"
    self             = "false"
    to_port          = 8080
  }

  name   = "ssh-security-group"
  vpc_id = aws_vpc.demo-vpc.id
}

#AWS Key pair
resource "aws_key_pair" "cg-ec2-key-pair" {
  key_name   = "demo-env"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "local_file" "private_key" {
  content  = tls_private_key.ssh_key.private_key_pem
  filename = "accurics-generated-key.pem"
}

resource "aws_instance" "web-app-instance" {
  ami                         = "ami-074251216af698218"
  associate_public_ip_address = "true"

  subnet_id = aws_subnet.subnet-1.id

  vpc_security_group_ids = [aws_security_group.web-app-security-group.id]

  iam_instance_profile = aws_iam_instance_profile.web-app-instance-profile.name

  disable_api_termination = "false"
  ebs_optimized           = "false"

  enclave_options {
    enabled = "false"
  }

  get_password_data  = "false"
  hibernation        = "false"
  instance_type      = "t2.micro"
  ipv6_address_count = "0"
  key_name           = aws_key_pair.cg-ec2-key-pair.key_name

  metadata_options {
    http_endpoint               = "enabled"
    http_put_response_hop_limit = "1"
    http_tokens                 = "optional"
  }

  monitoring = "false"
  private_ip = "10.10.10.55"

  root_block_device {
    delete_on_termination = "true"
    encrypted             = "false"
    throughput            = "0"
    volume_size           = "8"
    volume_type           = "gp2"
  }

  source_dest_check = "true"

  tags = {
    Name = "web-app-instance"
  }

  tenancy = "default"

  provisioner "file" {
    source      = "./assets/ssrf_app/app.zip"
    destination = "/home/ubuntu/app.zip"
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = tls_private_key.ssh_key.private_key_pem
      host        = self.public_ip
    }
  }
  user_data = <<-EOF
        #!/bin/bash
        apt-get update
        curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
        DEBIAN_FRONTEND=noninteractive apt-get -y install nodejs unzip
        npm install http express needle command-line-args
        cd /home/ubuntu
        unzip app.zip -d ./app
        cd app
        sudo node ssrf-demo-app.js &
        echo -e "\n* * * * * root node /home/ubuntu/app/ssrf-demo-app.js &\n* * * * * root sleep 10; node /home/ubuntu/app/ssrf-demo-app.js &\n* * * * * root sleep 20; node /home/ubuntu/app/ssrf-demo-app.js &\n* * * * * root sleep 30; node /home/ubuntu/app/ssrf-demo-app.js &\n* * * * * root sleep 40; node /home/ubuntu/app/ssrf-demo-app.js &\n* * * * * root sleep 50; node /home/ubuntu/app/ssrf-demo-app.js &\n" >> /etc/crontab
        EOF

  volume_tags = {
    Name = "web-app-instance"
  }

}

resource "aws_instance" "privileged-instance" {
  ami                         = "ami-074251216af698218"
  associate_public_ip_address = "true"

  disable_api_termination = "false"
  ebs_optimized           = "false"

  enclave_options {
    enabled = "false"
  }

  get_password_data    = "false"
  hibernation          = "false"
  iam_instance_profile = aws_iam_instance_profile.privileged-instance-profile.name
  instance_type        = "t2.micro"
  ipv6_address_count   = "0"
  key_name             = aws_key_pair.cg-ec2-key-pair.key_name

  metadata_options {
    http_endpoint               = "enabled"
    http_put_response_hop_limit = "1"
    http_tokens                 = "optional"
  }

  monitoring = "false"
  private_ip = "10.10.20.69"

  root_block_device {
    delete_on_termination = "true"
    encrypted             = "false"
    throughput            = "0"
    volume_size           = "8"
    volume_type           = "gp2"
  }

  source_dest_check = "true"
  subnet_id         = aws_subnet.subnet-2.id

  tags = {
    Name = "instance-2"
  }

  tenancy = "default"

  vpc_security_group_ids = [aws_security_group.web-app-security-group.id]

  volume_tags = {
    Name = "instance-2"
  }

}

output "public_dns" {
  description = "List of public DNS names assigned to the instances. For EC2-VPC, this is only available if you've enabled DNS hostnames for your VPC"
  value       = aws_instance.web-app-instance.public_dns
}