resource "aws_instance" "negative3-1" {
  ami                         = "ami-074251216af698218"
  instance_type      = "t2.micro"

  root_block_device {
    delete_on_termination = true
    encrypted             = true
    throughput            = "0"
    volume_size           = "8"
    volume_type           = "gp2"
  }
}


resource "aws_instance" "negative3-2" {
  ami           = "ami-0c55b159cbfafe1f0" 
  instance_type = "t3.micro"

  ebs_block_device {
    device_name           = "/dev/sdh"
    volume_size           = 10         
    volume_type           = "gp3"
    delete_on_termination = true
    encrypted             = true
  }
}
