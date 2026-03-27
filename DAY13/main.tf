data "aws_vpc" "default" {
  default = true

}

data "aws_subnets" "default_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_launch_template" "example" {
  image_id               = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids = var.security_group_ids

  user_data = base64encode(templatefile("${path.module}/user-data.sh", {

  }))

  lifecycle {
    create_before_destroy = true
  }
}

resource "random_id" "server" {
  keepers = {
    # A new random ID is generated when the launch configuration changes
    ami_id = var.ami_id
  }
  byte_length = 8
}

resource "aws_autoscaling_group" "example" {
  # Use name_prefix instead of name to let AWS generate a unique name
  name_prefix = "${var.cluster_name}-"
  launch_template {
    id      = aws_launch_template.example.id
    version = "$Latest"
  }

  vpc_zone_identifier = data.aws_subnets.default_subnets.ids

  target_group_arns = [aws_lb_target_group.green_tg.arn, aws_lb_target_group.blue_tg.arn]
  health_check_type = "ELB"

  min_size = var.min_size
  max_size = var.max_size

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = var.cluster_name
    propagate_at_launch = true
  }
}
#App load balancer
resource "aws_lb" "web_lb" {
  name               = var.cluster_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_group_ids
  subnets            = data.aws_subnets.default_subnets.ids
}
#Target groups green tg
resource "aws_lb_target_group" "green_tg" {
  name     = "${var.cluster_name}-green-tg"
  port     = var.port
  protocol = var.protocol
  vpc_id   = data.aws_vpc.default.id
  health_check {
    path                = "/"
    protocol            = var.protocol
    matcher             = 200
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

}

#Target groups blue tg
resource "aws_lb_target_group" "blue_tg" {
  name     = "${var.cluster_name}-blue-tg"
  port     = var.port
  protocol = var.protocol
  vpc_id   = data.aws_vpc.default.id
  health_check {
    path                = "/"
    protocol            = var.protocol
    matcher             = 200
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

}

#Listeners for the target groups.
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.web_lb.arn
  port              = var.port
  protocol          = var.protocol
  default_action {
    type             = "forward"
    target_group_arn = var.active_environmet == "blue" ? aws_lb_target_group.blue_tg.arn : aws_lb_target_group.green_tg.arn

  }

}


output "active_environment" {
    value = var.active_environmet
  
}
output "lb_dns_name" {
    value = aws_lb.web_lb.dns_name
    description = "the dns name of the load balancer"
}
output "app_version" {
    value = var.app_version
  
}