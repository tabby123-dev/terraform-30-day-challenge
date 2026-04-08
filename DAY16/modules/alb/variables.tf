variable "tags" {
  description = "Tags to apply to all resources."
  type        = map(string)
}

variable "subnet_ids" {
    type = list(string)
  
}
variable "alb_sg_id" {
    type = string
  
}
variable "vpc_id" {
    type = string
  
}
variable "ec2_sg_id" {
    type = string
  
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
