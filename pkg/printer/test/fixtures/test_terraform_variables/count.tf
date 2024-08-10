resource "aws_instance" "server" {
	count         = true == true ? 0 : 1
  
	subnet_id     = var.subnet_ids[count.index]
  
	ami           = "ami-a1b2c3d4"
	instance_type = "t2.micro"
}
  
resource "aws_instance" "server1" {
	count         = length(var.subnet_ids)
  
	ami           = "ami-a1b2c3d4"
	instance_type = "t2.micro"
	subnet_id     = var.subnet_ids[count.index]
}
