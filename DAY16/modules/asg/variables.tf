variable "tags" {
  description = "Tags to apply to all resources."
  type        = map(string)
}

variable "subnet_ids" {
  type = list(string)
}
variable "launch_template_id" {
  type = string
}
variable "target_group_arn" {
  type = string
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