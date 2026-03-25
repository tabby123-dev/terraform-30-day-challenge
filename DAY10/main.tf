terraform {

  backend "s3" {
    bucket         = "terraform-running"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}

provider "aws" {
  region = "us-east-1"
}
/*
# Fragile — removing "alice" from position 0 causes bob and charlie to be recreated
variable "user_names" {
  type    = list(string)
  default = ["alice", "bob", "charlie"]
}

resource "aws_iam_user" "example" {
  count = length(var.user_names)
  name  = var.user_names[count.index]
}
*/

variable "users" {
  type = map(object({
    department = string
    admin      = bool
  }))
  default = {
    alice = { department = "engineering", admin = true }
    bob   = { department = "marketing",   admin = false }
  }
}

resource "aws_iam_user" "example" {
  for_each = var.users
  name     = each.key
  tags = {
    Department = each.value.department
  }
}

variable "enable_autoscaling" {
  description = "Enable autoscaling for the cluster"
  type        = bool
  default     = true
}

variable "environment" {
    type = string
    default = "stage"
  
}
resource "aws_autoscaling_policy" "scale_out" {
  count = var.enable_autoscaling ? 1 : 0
  name ="demo_asgp"
  autoscaling_group_name = "demo"

}
locals {
  instance_type = var.environment == "production" ? "t2.small" : "t3.micro"
}
output "instance_type" {
    value = local.instance_type
  
}