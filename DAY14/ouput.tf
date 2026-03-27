output "region1" {
    value = data.aws_region.region1
    description = "region1"
  
}

output "region2" {
    value = data.aws_region.region2
    description = "region2"
  
}
output "aws_instance_server1_az" {
value = aws_instance.server1.availability_zone
description = "The AZ where the instance in the first region deployed"
}
output "aws_instance_server2_az" {
value = aws_instance.server2.availability_zone
description = "The AZ where the instance in the second region deployed"
}

