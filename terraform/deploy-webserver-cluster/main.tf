provider "aws" {
  region = "eu-central-1"
}

resource "aws_launch_configuration" "example" {
  image_id        = "ami-0e0102e3ff768559b"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.instance.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p ${var.server_port} &
              EOF

  # Required when using aws_launch_configuration with an auto scaling group.
  # Fixes dependency issues by creating new resources before deleting old ones.
  # https://bit.ly/2OVc9Jz
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "instance" {
  name = var.security_group_name

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_autoscaling_group" "example" {
  launch_configuration = aws_launch_configuration.example.name
  # use aws_subnet_ids data source to look up the subnets inside default vpc
  vpc_zone_identifier = data.aws_subnet_ids.default.ids

  # allow target group to know which ec2 instances to send traffic to
  target_group_arns = [aws_lb_target_group.asg.arn]
  # elb health checks check for completely down instances and instances that stop serving requests
  health_check_type = "ELB" # default is ec2

  min_size = 2
  max_size = 10

  tag {
    key                 = "Name"
    value               = "terraform-asg-example"
    propagate_at_launch = true
  }
}

# arguments passed to data sources act as search filters
data "aws_vpc" "default" {
  default = true
}

# use a data source as a search filter to obtain another data source
data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

# create an alb type load balancer
resource "aws_lb" "example" {
  name               = "terraform-asg-example"
  load_balancer_type = "application"
  subnets            = data.aws_subnet_ids.default.ids
  security_groups    = [aws_security_group.alb.id]
}

# sends requests that match any path to the target group associated with the asg
resource "aws_lb_listener_rule" "asg" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.asg.arn
  }
}

# listens to a specific port and protocol
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.example.arn
  port              = 80
  protocol          = "HTTP"

  # return 404 page if there's an error
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}

resource "aws_security_group" "alb" {
  name = "terraform-example-alb"

  #Allow inbound traffic
  ingress {
    from_port  = 80
    to_port    = 80
    protocol   = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #Allow outbound traffic
  egress {
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# target group will check instances periodically sending an http requests
resource "aws_lb_target_group" "asg" {
  name     = "terraform-asg-example"
  port     = var.server_port
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}