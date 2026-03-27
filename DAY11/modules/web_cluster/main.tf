locals {
  is_production = var.environment == "production"

  instance_type = local.is_production ?  "t2.medium" : "t2.micro"
  min_size = local.is_production ? 3 : 1
  max_size = local.is_production ? 10 : 3

  enable_monitoring = local.is_production || var.enable_detailed_monitoring
  vpc_id = var.use_existing_vpc ? data.aws_vpc.existing.id : aws_vpc.new_vpc
}

data "aws_vpc" "existing" {
  count = var.use_existing_vpc ? 1 : 0
  
}
/*

data "aws_vpc" "default" {
    default = true
  
}
*/
data "aws_subnets" "default_subnets" {
    filter {
      name = "vpc-id"
      values = [data.aws_vpc.existing.id]
    }
  
}
resource "aws_vpc" "new_vpc" {
  count = var.use_existing_vpc ? 0 : 1
  
}

resource "aws_launch_template" "template1" {
    name_prefix = "${var.launch_template_name}-dev1"
    image_id = var.ami_id
    instance_type = local.instance_type
    vpc_security_group_ids = var.security_group_ids
    tag_specifications {
      resource_type = "instance"
      tags = {
        Name = var.instance_name
      }
    }
    user_data = base64encode(templatefile("${path.module}/userdata.sh",{
        launch_template_name = var.launch_template_name
    }))
  
}
resource "aws_autoscaling_group" "web_asg" {
    name = "${var.instance_name}-asg"
    max_size = local.max_size
    min_size = local.min_size
    health_check_grace_period = var.health_check_grace_period
    health_check_type = var.health_check_type
    desired_capacity = local.min_size
    vpc_zone_identifier = data.aws_subnets.default_subnets.ids
    launch_template {
      id = aws_launch_template.template1.id
      version = "$Latest"
    }
    target_group_arns = [aws_lb_target_group.web_tg.arn]
    tag {
      key = "Name"
      value = "${var.instance_name}-asgweb"
      propagate_at_launch = true
    } 
}
resource "aws_lb" "web_lb" {
    name = "${var.instance_name}-alb"
    internal = false
    load_balancer_type = "application"
    security_groups = var.security_group_ids
    subnets = data.aws_subnets.default_subnets.ids
}
resource "aws_lb_target_group" "web_tg" {
    name = var.lb_target_grp
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
resource "aws_lb_listener" "listener" {
    load_balancer_arn = aws_lb.web_lb.arn
    port = var.port
    protocol = var.protocol
    default_action {
      type = "forward"
      target_group_arn = aws_lb_target_group.web_tg.arn
    }
  
}

resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  count = var.enable_detailed_monitoring ? 1 : 0

  alarm_name          = "${var.launch_template_name}-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "CPU utilization exceeded 80%"
}
















/*
resource "aws_autoscaling_schedule" "scale_out_during_bussines_hours" {
    count = var.enable_autoscaling ? 1 : 0
    scheduled_action_name = "${var.launch_template_name}-scale-out-during-bussines-hours"
    min_size = var.min_size
    max_size = var.max_size
    recurrence = "0 9 * * *"
    autoscaling_group_name = aws_autoscaling_group.web_asg.name
  
}
*/
