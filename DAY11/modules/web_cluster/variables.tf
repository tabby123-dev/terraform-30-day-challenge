variable "environment" {
    type = string
    default = "dev"
  
}


variable "launch_template_name" {
  description = "Name for the launch template"
  #default = "web-server-template"
  
}
variable "ami_id" {
    description = "name for the ami id"
    default = "ami-0ec10929233384c7f"
}
variable "instance_type" {
    description = "type of instnace"
    #default = "t2.micro"
}
variable "security_group_ids" {
  description = "List of security group IDs"
  type        = list(string)

  default = ["sg-07fd664f95c3daf73"]
}
variable "instance_name" {
    type = string
    #default = "Webserver"
  
}
variable "region" {
    default = "us-east-1"
  
}
variable "max_size" {
    default = 4
  
}
variable "min_size" {
    default = 2
  
}
variable "health_check_grace_period" {
    type = number
    default = 300
  
}
variable "health_check_type" {
    default = "ELB"
  
}
variable "lb_target_grp" {
    type = string
    #default = "web-tg"
  
}
variable "port" {
    default = 80
  
}
variable "protocol" {
    type = string
    default = "HTTP"
  
}
variable "enable_autoscaling" {
    description = "if set to true enable auroscaling"
  
}
variable "enable_detailed_monitoring" {
    description = "enable cloud watch"
    type = bool
    default = false
  
}

