locals {
  common_tags = {

  }
}
resource "aws_autoscaling_group" "asg" {
    desired_capacity = var.desired_capacity
    max_size = var.max_size
    min_size = var.min_size
    vpc_zone_identifier = var.subnet_ids
    launch_template {
      id = var.launch_template_id
      version = var.template_version
    }
    target_group_arns = [var.target_group_arn]
    health_check_type = var.health_check_type
    tag {
      key = var.key_name
      value = var.key_value
      propagate_at_launch = var.propagate_at_launch
    }
    
  
}