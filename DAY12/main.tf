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
    key    = "zdm/terraform.tfstate"
    region = "us-east-1"

  }

}
resource "random_id" "server" {
  keepers = {
    # A new random ID is generated when the launch configuration changes
    ami_id = var.ami_id
  }
  byte_length = 8
}

data "aws_vpc" "default" {
    default = true
  
}

data "aws_subnets" "default_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

#Launch configuration
resource "aws_launch_template" "template" {
  name_prefix            = "${var.cluster_name}-"
  image_id               = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids = var.security_group_ids
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = var.instance_name
    }
  }

  user_data = base64encode(templatefile("${path.module}/user-data.sh", {}))

  lifecycle {
    create_before_destroy = true
  }

}

#Auto scaling Group with naming prefix to vaoid conflicts
resource "aws_autoscaling_group" "web_asg" {
    name_prefix = "${var.cluster_name}-"
    max_size = var.max_size
    min_size = var.min_size
    health_check_grace_period = var.health_check_grace_period
    health_check_type = var.health_check_type
    desired_capacity = var.min_size
    vpc_zone_identifier = data.aws_subnets.default_subnets.ids
    launch_template {
      id = aws_launch_template.template.id
      version = "$Latest"
    }
    target_group_arns = [var.active_environmet == "blue" ? aws_lb_target_group.blue_tg.arn : aws_lb_target_group.green_tg.arn ]
    tag {
      key = "Name"
      value = "${var.cluster_name}-${var.app_version}"
      propagate_at_launch = true
    } 
    lifecycle {
      create_before_destroy = true
    }
}

#App load balancer
resource "aws_lb" "web_lb" {
    name = "${var.cluster_name}"
    internal = false
    load_balancer_type = "application"
    security_groups = var.security_group_ids
    subnets = data.aws_subnets.default_subnets.ids
}
#Target groups green tg
resource "aws_lb_target_group" "green_tg" {
    name = "${var.cluster_name}-green-tg"
    port = var.port
    protocol = var.protocol
    vpc_id = data.aws_vpc.default.id
    health_check {
      path = "/"
      protocol = var.protocol
      matcher = 200
      interval =  15
      timeout = 3
      healthy_threshold = 2
      unhealthy_threshold = 2
    }
  
}
#Target groups blue tg
resource "aws_lb_target_group" "blue_tg" {
    name = "${var.cluster_name}-blue-tg"
    port = var.port
    protocol = var.protocol
    vpc_id = data.aws_vpc.default.id
    health_check {
      path = "/"
      protocol = var.protocol
      matcher = 200
      interval =  15
      timeout = 3
      healthy_threshold = 2
      unhealthy_threshold = 2
    }
  
}

#Listeners for the target groups.
resource "aws_lb_listener" "listener" {
    load_balancer_arn = aws_lb.web_lb.arn
    port = var.port
    protocol = var.protocol
    default_action {
      type = "forward"
      target_group_arn = var.active_environmet == "blue" ? aws_lb_target_group.blue_tg.arn : aws_lb_target_group.green_tg.arn

    }
  
}