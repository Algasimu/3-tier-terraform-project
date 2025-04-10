#### Security group for EC2 instances

resource "aws_security_group" "apci_jupiter_server_sg" {
  name        = "apci-jupiter-server-sg"
  description = "Allow SSH, HTTP and HTTPS traffic"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-public-server-sg"
  })
}

resource "aws_vpc_security_group_ingress_rule" "ssh_ingress_rule" {
  security_group_id = aws_security_group.apci_jupiter_server_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "http_ingress_rule" {
  security_group_id = aws_security_group.apci_jupiter_server_sg.id
  referenced_security_group_id = var.apci_jupiter_alb_sg_id
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "https_ingress_rule" {
  security_group_id = aws_security_group.apci_jupiter_server_sg.id
  referenced_security_group_id = var.apci_jupiter_alb_sg_id
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.apci_jupiter_server_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# CREATING LAUNCH TEMPLATE FOR JUPITER SERVER----------------------------------------------------------------------------------------------------------------
resource "aws_launch_template" "apci_jupiter_lt" {
  name_prefix   = "apci-lt"
  image_id      = var.image_id   #### ami-0fc82f4dabc05670b east-2
  instance_type = var.instance_type  ### t2.micro
  key_name = var.key_name
  user_data = base64encode(file("scripts/jupiter-app.sh"))
    network_interfaces {
    associate_public_ip_address = true
    security_groups = [aws_security_group.apci_jupiter_server_sg.id]
  }
}

### The auto scaling group
resource "aws_autoscaling_group" "apci_jupiter_asg" {
  name                      = "apci-jupiter-asg"
  max_size                  = 5
  min_size                  = 2
  health_check_grace_period = 300 #### This is the time that the auto-scaling group uses to check the health of a newly created instance
  health_check_type         = "ELB"  ## This our application load balancer
  desired_capacity          = 4
  force_delete              = true   ## This will allow the instances to be deleted 
  vpc_zone_identifier       = [var.apci_jupiter_public_subnet_az_2a_id, var.apci_jupiter_public_subnet_az_2b_id] ## This specifies the subnets where the instances will be created 
  target_group_arns         = [var.apci_jupiter_target_group_arn] ## this register the instances(from the auto-scaling) to the target group
  launch_template {
    id = aws_launch_template.apci_jupiter_lt.id
    version = "$Latest"
  }
  tag {
    key = "Name"
    value = "apci-jupiter-app-server"
    propagate_at_launch = true
  }
}