########### Security group for the Bastion host ################
resource "aws_security_group" "apci_jupiter_bastion_sg" {
  name        = "apci-jupiter-bastion-sg"
  description = "Allow SSH traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name = "bastion-host-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.apci_jupiter_bastion_sg.id
  cidr_ipv4         = "0.0.0.0/0" # allow ssh from everywhere
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_ssh_outbout_traffic" {
  security_group_id = aws_security_group.apci_jupiter_bastion_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

############ Create the bastion host ec2 ##############################
resource "aws_instance" "apci_jupiter_bastion_host" {
  ami           = var.image_id
  instance_type = var.instance_type
  security_groups = [aws_security_group.apci_jupiter_bastion_sg.id]
  subnet_id =   var.apci_jupiter_public_subnet_az_2a_id
  associate_public_ip_address = true
  key_name =  var.key_name
  
  
tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-Bastion-Host"
  })  
}

#---------------------------------------------------------------------------------------------------------------
###########  Create private servers security group ##############################

resource "aws_security_group" "apci_jupiter_private_server_sg" {
  name        = "apci-jupiter-private-server-sg"
  description = "Allow SSH traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name = "private-server-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_access" {
  security_group_id = aws_security_group.apci_jupiter_private_server_sg.id
  referenced_security_group_id = aws_security_group.apci_jupiter_bastion_sg.id
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_ssh_outbout_traffic" {
  security_group_id = aws_security_group.apci_jupiter_private_server_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

################################ Create Private servers in AZ 2A ##############################

resource "aws_instance" "apci_jupiter_private_server_az_2a" {
  ami           = var.image_id
  instance_type = var.instance_type
  security_groups = [aws_security_group.apci_jupiter_private_server_sg.id]
  subnet_id = var.apci_jupiter_private_subnet_az_2a  
  associate_public_ip_address = false
  key_name =  var.key_name
  
tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-Private-Server"
  })  
}
################################ Create Private servers in AZ 2B ##############################
resource "aws_instance" "apci_jupiter_private_server_az_2b" {
  ami           = var.image_id
  instance_type = var.instance_type
  security_groups = [aws_security_group.apci_jupiter_private_server_sg.id]
  subnet_id = var.apci_jupiter_private_subnet_az_2b 
  associate_public_ip_address = false
  key_name =  var.key_name
  
tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-Private-Server"
  })  
}

