
resource "aws_instance" "web" {
    ami = "ami-02dfbd4ff395f2a1b"
    #instance_type = lookup(var.instance_type, terraform.workspace, "t2.micro")
    instance_type = var.instance_type
    tags = {
      name = "web-stage"
      environment = "stage"
    }
  
}