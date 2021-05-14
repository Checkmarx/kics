provider "aws2" {
  profile = "default"
  region  = "us-west-2"
}

data "aws_availability_zones" "available2" {
  state = "available"
}

data "aws_ami" "ubuntu2" {
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

resource "aws_subnet" "subnet12" {
  vpc_id = aws_vpc.vpc1.id
  cidr_block = "10.10.10.0/24"
  availability_zone_id = data.aws_availability_zones.available2.zone_ids[0]
  tags = {
    Name = "subnet1"
  }
}

resource "aws_subnet" "subnet22" {
  vpc_id = aws_vpc.vpc1.id
  cidr_block = "10.10.11.0/24"
  availability_zone_id = data.aws_availability_zones.available2.zone_ids[1]

  tags = {
    Name = "subnet2"
  }
}

resource "aws_lb" "test2" {
  name = "test123"
  load_balancer_type = "application"
  subnets = [aws_subnet.subnet12.id, aws_subnet.subnet22.id]
  internal = true
}

resource "aws_lb_target_group" "test2" {
  port = 80
  protocol = "HTTP"
  target_type = "instance"
  vpc_id = aws_vpc.vpc1.id
}

resource "aws_default_security_group" "dsg2" {
  vpc_id = aws_vpc.vpc1.id
}

resource "aws_lb_listener" "listener2" {
  load_balancer_arn = aws_lb.test2.arn
  protocol = "HTTPS"
  port = 80
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test2.arn
  }
}

resource "aws_lb_target_group_attachment" "attach12" {
  target_group_arn = aws_lb_target_group.test2.arn
  target_id = aws_instance.inst12.id
  port = 80
}

resource "aws_instance" "inst12" {
  vpc_security_group_ids = [aws_default_security_group.dsg2.id]
  subnet_id = aws_subnet.subnet12.id
  ami = data.aws_ami.ubuntu2.id
  instance_type = "t3.micro"
}

resource "aws_lb_target_group_attachment" "attach22" {
  target_group_arn = aws_lb_target_group.test2.arn
  target_id = aws_instance.inst22.id
  port = 80
}

resource "aws_instance" "inst22" {
  vpc_security_group_ids = [aws_default_security_group.dsg2.id]
  subnet_id = aws_subnet.subnet12.id
  ami = data.aws_ami.ubuntu2.id
  instance_type = "t3.micro"
}

resource "aws_lb_target_group_attachment" "attach32" {
  target_group_arn = aws_lb_target_group.test2.arn
  target_id = aws_instance.inst32.id
  port = 80
}

resource "aws_instance" "inst32" {
  vpc_security_group_ids = [aws_default_security_group.dsg2.id]
  subnet_id = aws_subnet.subnet12.id
  ami = data.aws_ami.ubuntu2.id
  instance_type = "t3.micro"
}
