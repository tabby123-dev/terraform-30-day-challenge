
resource "aws_instance" "web" {
    ami = "ami-02dfbd4ff395f2a1b"
    instance_type = var.instance_type[terraform.workspace]
    tags = {
      name = "web-${terraform.workspace}"
      environment = terraform.workspace
    }
  
}