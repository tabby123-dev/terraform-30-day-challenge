terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}
provider "aws" {
  region = "us-east-2"
  alias  = "region1"
  assume_role {
    role_arn = "arn:aws:iam::111111111:role/TerraformDeployRole"
  }

}
provider "aws" {
  region = "us-west-1"
  alias  = "region2"
  assume_role {
    role_arn = "arn:aws:iam::222222222222:role/TerraformDeployRole"
  }

}
data "aws_region" "region1" {
  provider = aws.region1
}
data "aws_region" "region2" {
  provider = aws.region2

}

data "aws_ami" "ubuntu_region1" {
  provider    = aws.region1
  most_recent = true
  owners      = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}
data "aws_ami" "ubuntu_region2" {
  provider    = aws.region2
  most_recent = true
  owners      = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}
resource "aws_instance" "server1" {
  ami           = data.aws_ami.ubuntu_region1.id
  instance_type = var.instance_type
  provider      = aws.region1


}
resource "aws_instance" "server2" {
  ami           = data.aws_ami.ubuntu_region2.id
  instance_type = var.instance_type
  provider      = aws.region2

}
