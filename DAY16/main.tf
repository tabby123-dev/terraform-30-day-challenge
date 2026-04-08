locals {
  common_tags = {
    environment = var.environment
    project     = var.project_name
    owner       = var.owner
    managed_by  = "Terraform"
  }
}


module "alb" {
    source = "./modules/alb"
    subnet_ids = var.subnet_ids
    alb_sg_id = var.alb_sg_id
    vpc_id = var.vpc_id
    ec2_sg_id = var.ec2_sg_id
    lb_name = var.lb_name
    loadbalancer_type = var.loadbalancer_type
    lbtg_name = var.lbtg_name   
    protocol = var.protocol
    path = var.path
    port = var.port
    tags = local.common_tags

  
}
module "launch-template" {
    source = "./modules/launch-template"
    subnet_ids = var.subnet_ids
    ec2_sg_id = var.ec2_sg_id
    vpc_id = var.vpc_id
    ami_id = var.ami_id
    instance_type = var.instance_type
    template_name = var.template_name
    tags = local.common_tags

}
module "asg" {
    source = "./modules/asg"
    subnet_ids = var.subnet_ids
    launch_template_id = module.launch-template.template_id
    target_group_arn = module.alb.target_group_arn
    desired_capacity = var.desired_capacity
    max_size = var.max_size
    min_size = var.min_size
    template_version = var.template_version
    health_check_type = var.health_check_type
    key_name = var.key_name
    key_value = var.key_value
    propagate_at_launch = var.propagate_at_launch
    tags = local.common_tags

}