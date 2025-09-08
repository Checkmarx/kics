resource "aws_instance" "example1" {
  ami                         = "ami-074251216af698218"
  instance_type      = "t2.micro"

  root_block_device {
    throughput            = "0"
    volume_size           = "8"
    volume_type           = "gp2"
  }

  tags = {
    Name = "web-app-instance"
  }
}

resource "aws_instance" "example2" {
  ami           = "ami-0c55b159cbfafe1f0" 
  instance_type = "t3.micro"

  tags = {
    Name = "web-app-instance"
  }

  ebs_block_device {
    device_name           = "/dev/sdh" 
    volume_size           = 10         
    volume_type           = "gp3"
  }
}
