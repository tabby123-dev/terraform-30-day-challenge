variable "region" {
  default = "us-east-1"
}

variable "profile" {
  default = "terraform-user"
}

variable "sg_id" {
  default = "sg-0a4c3ebecc7e40048"
}

variable "vpc_id" {
  default = "vpc-09c2918532eb101f1"
}

variable "lb_subnet_id" {
  default = ["subnet-026e06f1b4172e999","subnet-04881e4515924845d"]
}

variable "web_subnet_id" {
  default = ["subnet-026e06f1b4172e999","subnet-04881e4515924845d"]
}

variable "ami" {
  default = "ami-0c02fb55956c7d316"
}

variable "instance_shape" {
  default = "t2.micro"
}

variable "launch_name" {
  default = "app-lt"
}

variable "portno" {
  default = 80
}

variable "protocol" {
  default = "HTTP"
}

variable "app_tg" {
  default = "app-tg"
}

variable "app_alb" {
  default = "app-alb"
}

variable "load_balancer_type" {
  default = "application"
}

variable "min_size" {
  default = 2
}

variable "max_size" {
  default = 5
}

variable "instnace_name" {
  default = "DAY4-instance"
}