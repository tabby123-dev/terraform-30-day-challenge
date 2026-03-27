terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
  backend "s3" {
    bucket = "terraform-running"
    key    = "secret/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
    use_lockfile = true

  }

}
data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}
# EC2 instance
resource "aws_instance" "my_instance" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
 # vpc_security_group_ids = [aws_security_group.ssh_access.id]

  tags = {
    Name = "Terraform-EC2"
  }
}

output "ami_id" {
  value = data.aws_ami.amazon_linux.id
  sensitive = true
}
output "public_ip" {
  value = aws_instance.my_instance.public_ip
  sensitive = true
}