terraform {
  backend "s3" {
    bucket = "terraform-running"
    key = "dev/terraform.tfstate"
    region = "us-east-1"
    
  }
}
module "web_cluster" {
    source = "../../modules/web_cluster"
    instance_type = "t2.small"
    instance_name = "dev-webserver"
    lb_target_grp = "dev-tg"
    launch_template_name = "dev-web-server-template"
    enable_autoscaling = false
    
  
}

output "alb_dns_name" {
  value = module.web_cluster.alb_dns_name
}
