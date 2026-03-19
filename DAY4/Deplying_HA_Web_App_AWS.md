## Difference Between Configurable and Clustered

What I deployed today was a **clustered architecture**, whereas earlier (Day 3) was a **single configurable server**.

- A configurable setup focuses on flexibility within a single instance using variables.
- A clustered setup involves multiple instances working together behind a load balancer.

Clustering solves several key problems that a single server cannot:

- **High availability**: If one instance fails, others continue serving traffic.  
- **Scalability**: Traffic can be distributed across multiple instances.  
- **Fault tolerance**: Reduces single points of failure.  
- **Performance**: Load balancing improves response times under heavy traffic.  

```hcl
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    name=var.vpc_name
  }
}
resource "aws_subnet" "public" {
  count = length(data.aws_availability_zones.available.names)

  vpc_id = aws_vpc.main.id

  cidr_block = cidrsubnet(
    aws_vpc.main.cidr_block,
    8,
    count.index
  )

  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-${count.index}"
  }
}
resource "aws_security_group" "alb_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = var.portno
    to_port     = var.portno
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "ec2_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port       = var.portno
    to_port         = var.portno
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_launch_template" "app" {
  name_prefix   = "app-template"
  image_id      = "ami-00e1181affe35cfd8" # choose valid AMI
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  user_data = base64encode(<<-EOF
              #!/bin/bash
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "Hello from ASG TF Challenge Day 4" > /var/www/html/index.html
              EOF
  )
}
resource "aws_lb_target_group" "tg" {
  port     = var.portno
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}
resource "aws_lb" "alb" {
  load_balancer_type = "application"
  subnets            = aws_subnet.public[*].id
  security_groups    = [aws_security_group.alb_sg.id]
}
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = var.portno
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}
resource "aws_autoscaling_group" "asg" {
  min_size         = 2
  max_size         = 5
  desired_capacity = 2

  vpc_zone_identifier = aws_subnet.public[*].id

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.tg.arn]

  health_check_type = "ELB"
}
```
# Lab Takeaways and Challenges

## Lab Takeaways

Also learnt how to dynamically fetch existing resources from the cloud.  

I learned:  
- How to query existing resources (e.g., VPCs, subnets, AMIs)  
- How to integrate those values into new infrastructure  

---

## Challenges and Fixes

### 1. ALB Listener Configuration
**Problem:** Traffic was not being routed correctly.  

**Fix:**  
- Configured the listener to forward requests to the correct target group  
- Verified protocol and port alignment
