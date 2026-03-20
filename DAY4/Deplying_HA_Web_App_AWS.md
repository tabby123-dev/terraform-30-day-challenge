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
resource "aws_launch_template" "app" {
  name_prefix   = var.launch_name
  image_id      = var.ami
  instance_type = var.instance_shape

  vpc_security_group_ids = [var.sg_id] 

  user_data = base64encode(<<-EOF
              #!/bin/bash
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "Hello from Tabitha Terraform Day 4" > /var/www/html/index.html
              EOF
  )
}

resource "aws_lb_target_group" "app_tg" {
  name     = var.app_tg
  port     = var.portno
  protocol = var.protocol
  vpc_id   = var.vpc_id

  health_check {
    path = "/"
    port = var.portno
  }
}

resource "aws_lb" "app_alb" {
  name               = var.app_alb
  load_balancer_type = var.load_balancer_type
  security_groups    = [var.sg_id]          
  subnets            = var.lb_subnet_id    
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = var.portno
  protocol          = var.protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

resource "aws_autoscaling_group" "app_asg" {
  desired_capacity = var.min_size
  min_size         = var.min_size
  max_size         = var.max_size

  vpc_zone_identifier = var.web_subnet_id  

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.app_tg.arn]

  health_check_type = "EC2"

  tag {
    key                 = "Name"
    value               = var.instnace_name
    propagate_at_launch = true
  }
}  
```
<img width="356" height="55" alt="image" src="https://github.com/user-attachments/assets/2407c11f-8e77-4201-9254-814e8af8ebb8" />

# Takeaways and Challenges

#Takeaways

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
