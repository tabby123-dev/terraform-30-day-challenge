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