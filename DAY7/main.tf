variable "instance_type" {
    description = "EC2 instnace type per environment"
    type =  map(string)
    default = {
      "dev" = "t2.micro"
      "staging" = "t2.small"
      "prod" = "t2.medium"
    }
  
}
resource "aws_instance" "web" {
    ami = "ami-02dfbd4ff395f2a1b"
    instance_type = var.instance_type[terraform.workspace]
    tags = {
      name = "web-${terraform.workspace}"
      environment = terraform.workspace
    }
  
}