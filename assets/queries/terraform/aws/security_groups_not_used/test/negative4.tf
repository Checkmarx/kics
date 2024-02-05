terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  required_version = ">= 1.1.0"
}

variable "iam_role" {
  type        = string
  default     = "AmazonSSMRoleForInstancesQuickSetup"
  description = "Set AWS IAM role."
}

variable "ami_owner" {
  type        = string
  default     = "self"
  description = "Set AWS image owner."
}

variable "region" {
  type        = string
  default     = "eu-west-3"
  description = "Set AWS region."
}

variable "secgroups" {
  type        = list(string)
  default     = ["CowrieSSH"]
  description = "Set AWS security groups."
}

data "aws_ami" "cowrie" {
  most_recent = true
  owners      = ["var.ami_owner"]

  filter {
    name   = "name"
    values = ["cowrie-packer-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

provider "aws" {
  profile = "default"
  region  = var.region
}

resource "aws_security_group" "cowrie" {
  name        = "CowrieSSH"
  description = "CowrieSSH Terraform security group"

  ingress {
    description = "Allow anyone to connect to the honeypot."
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description      = "Allow all outgoing traffic."
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name    = "cowrie_ssh_sg"
    purpose = "honeypot"
  }
}

resource "aws_instance" "cowrie_server" {
  ami                  = data.aws_ami.cowrie.id
  instance_type        = "t3.nano"
  security_groups      = var.secgroups
  iam_instance_profile = var.iam_role

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = {
    Name    = "cowrie",
    author  = "foo"
    vcs-url = "https://github.com/foo/bar"
    purpose = "honeypot"
  }
}
