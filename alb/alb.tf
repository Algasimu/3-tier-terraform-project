
### Security group
######################
resource "aws_security_group" "apci_jupiter_alb_sg" {
  name        = "apci_jupiter-alb-sg"
  description = "Allow HTTP and HTPPS traffic"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-alb_sg"
  })
}

#### ingress rules HTTP
resource "aws_vpc_security_group_ingress_rule" "alb_http_inboud" {
  security_group_id = aws_security_group.apci_jupiter_alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

#### ingress rules HTTPS
resource "aws_vpc_security_group_ingress_rule" "alb_https_inboud" {
  security_group_id = aws_security_group.apci_jupiter_alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

#### ingress rules egress
resource "aws_vpc_security_group_egress_rule" "alb_egress_rule" {
  security_group_id = aws_security_group.apci_jupiter_alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
#### Target group

resource "aws_lb_target_group" "apci_jupiter_target_group" {
  name        = "apci-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id

    health_check {
    healthy_threshold   = 5
    interval            = 30
    matcher             = "200,301,302"
    path                = "/"
    port                = 80
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }
}

### Application load balancer
resource "aws_lb" "apci_jupiter_alb" {
  name               = "apci-jupiter-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.apci_jupiter_alb_sg.id]
  subnets            = [var.apci_jupiter_public_subnet_az_2a_id, var.apci_jupiter_public_subnet_az_2b_id]

  enable_deletion_protection = false

# access_logs {
#    bucket  = aws_s3_bucket.lb_logs.id
#   prefix  = "test-lb"
#   enabled = true
#  }

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-alb"
  })
}

### Create a listner on Port 80 with Redirect Action 
resource "aws_lb_listener" "apci_jupiter_alb_http_listner" {
  load_balancer_arn = aws_lb.apci_jupiter_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

### Create a lb lisner on port 443 with SSL certificate and default action
resource "aws_lb_listener" "apci_jupiter_alb_https_listner" {
  load_balancer_arn = aws_lb.apci_jupiter_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.apci_jupiter_target_group.arn
  }
}
