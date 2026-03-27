variable "cluster_name" {
  description = "Name for the launch template"
  default = "zero-downtime-cluster"
  
}
variable "ami_id" {
    description = "name for the ami id"
    default = "ami-0ec10929233384c7f"
}
variable "instance_type" {
    description = "type of instnace"
    default = "t2.micro"
}
variable "security_group_ids" {
  description = "List of security group IDs"
  type        = list(string)

  default = ["sg-07fd664f95c3daf73"]
}
variable "instance_name" {
    type = string
    default = "zero-dowtime"
  
}
variable "max_size" {
    default = 2
  
}
variable "min_size" {
    default = 1
  
}
variable "health_check_grace_period" {
    type = number
    default = 300
  
}
variable "health_check_type" {
    default = "ELB"
  
}

variable "port" {
    default = 80
  
}
variable "protocol" {
    type = string
    default = "HTTP"
  
}
variable "app_version" {
    type = string
    default = "v2"
  
}
variable "active_environmet" {
    description = "which env is active blue or green"
    default = "green"
  
}