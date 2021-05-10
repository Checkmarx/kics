provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_vpc" "vpc1" {
  cidr_block = "10.10.0.0/16"
}

resource "aws_subnet" "subnet1" {
  vpc_id = aws_vpc.vpc1.id
  cidr_block = "10.10.10.0/24"
  availability_zone_id = data.aws_availability_zones.available.zone_ids[0]
  tags = {
    Name = "subnet1"
  }
}

resource "aws_subnet" "subnet2" {
  vpc_id = aws_vpc.vpc1.id
  cidr_block = "10.10.11.0/24"
  availability_zone_id = data.aws_availability_zones.available.zone_ids[1]

  tags = {
    Name = "subnet2"
  }
}

resource "aws_lb" "test" {
  name = "test123"
  load_balancer_type = "application"
  subnets = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
  internal = true
}

resource "aws_lb_target_group" "test" {
  port = 80
  protocol = "HTTP"
  target_type = "instance"
  vpc_id = aws_vpc.vpc1.id
}

resource "aws_default_security_group" "dsg" {
  vpc_id = aws_vpc.vpc1.id
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.test.arn
  port = 80
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test.arn
  }
}

resource "aws_lb_target_group_attachment" "attach1" {
  target_group_arn = aws_lb_target_group.test.arn
  target_id = aws_instance.inst1.id
  port = 80
}

resource "aws_instance" "inst1" {
  vpc_security_group_ids = [aws_default_security_group.dsg.id]
  subnet_id = aws_subnet.subnet1.id
  ami = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
}

resource "aws_lb_target_group_attachment" "attach2" {
  target_group_arn = aws_lb_target_group.test.arn
  target_id = aws_instance.inst2.id
  port = 80
}

resource "aws_instance" "inst2" {
  vpc_security_group_ids = [aws_default_security_group.dsg.id]
  subnet_id = aws_subnet.subnet1.id
  ami = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
}

resource "aws_lb_target_group_attachment" "attach3" {
  target_group_arn = aws_lb_target_group.test.arn
  target_id = aws_instance.inst3.id
  port = 80
}

resource "aws_instance" "inst3" {
  vpc_security_group_ids = [aws_default_security_group.dsg.id]
  subnet_id = aws_subnet.subnet1.id
  ami = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
}
