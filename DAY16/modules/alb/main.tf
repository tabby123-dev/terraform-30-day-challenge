locals {
  common_tags = {

  }
}
resource "aws_lb" "this" {
    name = var.lb_name
    internal = false
    load_balancer_type = var.loadbalancer_type
    security_groups = [var.alb_sg_id]
    subnets = var.subnet_ids 
    tags = var.tags
    lifecycle {
      create_before_destroy = true
    }
 
  
}
resource "aws_lb_target_group" "lbtg" {
    name = var.lbtg_name
    port = var.port
    protocol = var.protocol
    vpc_id = var.vpc_id
    health_check {
      path = var.path
      port = "traffic-port"
    }
    tags = var.tags
}
resource "aws_lb_listener" "http" {
    load_balancer_arn = aws_lb.this.arn
    port = var.port
    protocol = var.protocol
    default_action {
      type = "forward"
      target_group_arn = aws_lb_target_group.lbtg.arn
    }
    tags = var.tags
  
}