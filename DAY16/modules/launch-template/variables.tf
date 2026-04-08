variable "tags" {
  description = "Tags to apply to all resources."
  type        = map(string)
}

variable "subnet_ids" {
    type = list(string)
  
}
variable "ec2_sg_id" {
  
}
variable "vpc_id" {
  
}
variable "ami_id" {
    type = string
  
}
variable "instance_type" {
    type = string
  
}
variable "template_name" {
    type = string
  
}