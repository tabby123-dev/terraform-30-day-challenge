terraform {
  backend "s3" {
    bucket = "terraform-running"
    key = "prod/terraform.tfstate"
    region = "us-east-1"
    
  }
}
module "web_cluster" {
    source = "../../modules/web_cluster"
    instance_type = "t2.micro"
    instance_name = "prod-webserver"
    lb_target_grp = "prod-tg"
    launch_template_name = "dev-web-server-template"


    
  
}
output "alb_dns_name" {
  value = module.web_cluster.alb_dns_name
}