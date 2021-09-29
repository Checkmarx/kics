module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "single-instance"

  ami                    = "ami-ebd02392"
  instance_type          = "t2.micro"
  key_name               = "user1"
  monitoring             = true
  vpc_security_group_ids = ["sg-12345678"]
  subnet_id              = "subnet-eddcdzz4"

  user_data_base64 = base64encode("apt-get install -y awscli; export AWS_ACCESS_KEY_ID=your_access_key_id_here; export AWS_SECRET_ACCESS_KEY=your_secret_access_key_here")


  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
