locals {
  common_tags = {
  }
}
resource "aws_launch_template" "template" {
    name = var.template_name
    image_id = var.ami_id
    instance_type = var.instance_type
    vpc_security_group_ids = [var.ec2_sg_id]
    user_data = base64encode(file("${path.module}/user-data.sh"))
    tags = var.tags
    
}