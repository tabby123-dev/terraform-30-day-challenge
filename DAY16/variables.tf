variable "environment" {
  type        = string
  description = "Deployment environment."

  validation {
    condition     = contains(["dev", "test", "stage", "prod"], lower(trimspace(var.environment)))
    error_message = "environment must be one of: dev, test, stage, prod."
  }
}
variable "project_name" {
    type = string
  
}
variable "owner" {
    type = string
  
}
variable "region" {
    default = "us-east-1"
}
variable "vpc_id" {
  
}
variable "subnet_ids" {
    type = list(string)
  
}
variable "alb_sg_id" {
  
}
variable "ec2_sg_id" {
  
}
variable "instance_type" {
  
}
variable "ami_id" {
  
}
variable "lb_name" {
    type = string
  
}
variable "loadbalancer_type" {
    type = string
  
}
variable "lbtg_name" {
    type = string
  
}  
variable "protocol" {
    type = string
  
}
variable "path" {
    type = string
  
}
variable "port" {
  type = number
}
variable "desired_capacity" {
    type = number
  
}
variable "max_size" {
    type = number
  
}
variable "min_size" {
    type = number
  
}
variable "template_version" {
    type = string
  
}
variable "health_check_type" {
  type = string
}
variable "key_name" {
  type = string
}
variable "key_value" {
    type = string
}
variable "propagate_at_launch" {
    type = bool
  
}
variable "template_name" {
    type = string
  
}