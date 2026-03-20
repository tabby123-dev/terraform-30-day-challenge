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