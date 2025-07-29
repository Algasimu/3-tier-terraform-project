
#####  Main VPC
resource "aws_vpc" "apci_jupiter_main_vpc" {
  cidr_block       = var.vpc_cidr_block 
  instance_tenancy = "default"

   tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-vpc"
  })  
}

####  Internet gateway 
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.apci_jupiter_main_vpc.id

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-igw"
  })
}

## Public subnet on Availability zone-2a
resource "aws_subnet" "apci_jupiter_public_subnet_az_2a" {
  vpc_id     = aws_vpc.apci_jupiter_main_vpc.id
  cidr_block = var.public_subnet_cidr_block[0]
  availability_zone = var.availability_zone[0]

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-pub-subnet-az-2a"
  })
}

## Public subnet on Availability zone-2b
resource "aws_subnet" "apci_jupiter_public_subnet_az_2b" {
  vpc_id     = aws_vpc.apci_jupiter_main_vpc.id
  cidr_block = var.public_subnet_cidr_block[1]
  availability_zone = var.availability_zone[1]

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-pub-subnet-az-2b"
  })
}

## Private subnet on Availability zone-2a
resource "aws_subnet" "apci_jupiter_private_subnet_az_2a" {
  vpc_id     = aws_vpc.apci_jupiter_main_vpc.id
  cidr_block = var.private_subnet_cidr_block[0]
  availability_zone = var.availability_zone[0]

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-priv-subnet-az-2a"
  })
}

## Private subnet on Availability zone-2b
resource "aws_subnet" "apci_jupiter_private_subnet_az_2b" {
  vpc_id     = aws_vpc.apci_jupiter_main_vpc.id
  cidr_block = var.private_subnet_cidr_block[1]
  availability_zone = var.availability_zone[1]

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-priv-subnet-az-2b"
  })
}

## DB Private subnet on Availability zone-2a
resource "aws_subnet" "apci_jupiter_db_subnet_az_2a" {
  vpc_id     = aws_vpc.apci_jupiter_main_vpc.id
  cidr_block = var.private_subnet_cidr_block[2]
  availability_zone = var.availability_zone[0]

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-db-subnet-az-2a"
  })
}

## DB Private subnet on Availability zone-2b
resource "aws_subnet" "apci_jupiter_db_subnet_az_2b" {
  vpc_id     = aws_vpc.apci_jupiter_main_vpc.id
  cidr_block = var.private_subnet_cidr_block[3]
  availability_zone = var.availability_zone[1]

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-db-subnet-az-2b"
  })
}

### Public Route tables
resource "aws_route_table" "apci_jupiter_public_route" {
  vpc_id = aws_vpc.apci_jupiter_main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-public-route"
  })
}

# Associate Route Table with subnet
resource "aws_route_table_association" "apci_jupiter_public_route_association_az_2a" {
  subnet_id      = aws_subnet.apci_jupiter_public_subnet_az_2a.id
  route_table_id = aws_route_table.apci_jupiter_public_route.id
}

resource "aws_route_table_association" "apci_jupiter_public_route_association_az_2b" {
  subnet_id      = aws_subnet.apci_jupiter_public_subnet_az_2b.id
  route_table_id = aws_route_table.apci_jupiter_public_route.id
}

#------------------------------------------------------------------------------------------------------------
# In this section, we build the Elastic IP, the NAT gateway, the private route, and associate this private route with  
# both the private subnet and the db_subnet in availability zone 2A.


## Elastic IP in availabily zone 2A
resource "aws_eip" "apci_jupiter_eip_az_2a" {
  domain   = "vpc"

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-eip-az-2a"
  })
}

### The NAT gateway.in availabily zone 2A
resource "aws_nat_gateway" "apci_jupiter_nat_gw_az_2a" {
  allocation_id = aws_eip.apci_jupiter_eip_az_2a.id
  subnet_id     = aws_subnet.apci_jupiter_public_subnet_az_2a.id

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-NAT-az-2a"
  })

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_eip.apci_jupiter_eip_az_2a, aws_subnet.apci_jupiter_public_subnet_az_2a]
}

### Private Route tables
resource "aws_route_table" "apci_jupiter_private_route" {
  vpc_id = aws_vpc.apci_jupiter_main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.apci_jupiter_nat_gw_az_2a.id
  }

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-private-route-AZ-2a"
  })
}

#### Private route table association in availabily zone 2A
resource "aws_route_table_association" "apci_jupiter_private_route_association_az_2a" {
  subnet_id      = aws_subnet.apci_jupiter_private_subnet_az_2a.id
  route_table_id = aws_route_table.apci_jupiter_private_route.id
}

#### Private route table association for db_subnet in availabily zone 2A
resource "aws_route_table_association" "apci_jupiter_private_db_route_association_az_2a" {
  subnet_id      = aws_subnet.apci_jupiter_db_subnet_az_2a.id
  route_table_id = aws_route_table.apci_jupiter_private_route.id
}
#------------------------------------------------------------------------------------------------------------
# In this section, we build the Elastic IP, the NAT gateway, the private route, and associate this private route with  
# both the private subnet and the db_subnet in availability zone 2B.

## Elastic IP  availability zone 2B
resource "aws_eip" "apci_jupiter_eip_az_2b" {
  domain   = "vpc"

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-eip-az-2b"
  })
}
### The NAT gateway availability zone 2B
resource "aws_nat_gateway" "apci_jupiter_nat_gw_az_2b" {
  allocation_id = aws_eip.apci_jupiter_eip_az_2b.id
  subnet_id     = aws_subnet.apci_jupiter_public_subnet_az_2b.id

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-NAT-az-2b"
  })

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_eip.apci_jupiter_eip_az_2b, aws_subnet.apci_jupiter_public_subnet_az_2b]
}

###Prive route tables in availability 2B
resource "aws_route_table" "apci_jupiter_private_route_az_2b" {
  vpc_id = aws_vpc.apci_jupiter_main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.apci_jupiter_nat_gw_az_2b.id
  }

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-private-route_az_2b"
  })
}


#### Private route table association in availabily zone 2B
resource "aws_route_table_association" "apci_jupiter_private_route_association_az_2b" {
  subnet_id      = aws_subnet.apci_jupiter_private_subnet_az_2b.id
  route_table_id = aws_route_table.apci_jupiter_private_route_az_2b.id
}

#### Private route table association in availabily zone 2B
resource "aws_route_table_association" "apci_jupiter_private_db_route_association_az_2b" {
  subnet_id      = aws_subnet.apci_jupiter_db_subnet_az_2b.id
  route_table_id = aws_route_table.apci_jupiter_private_route_az_2b.id
}

############## Create the S3 Bucket #######################

/*resource "aws_s3_bucket" "apci_jupiter_vpc_bucket" {
  bucket = "apci-jupiter-vpc-flow-log-v5"
}

############## Create a VPC flow log bucket #######################
resource "aws_flow_log" "apci_jupiter_vpc_flow_log" {
  log_destination      = aws_s3_bucket.apci_jupiter_vpc_bucket.arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.apci_jupiter_main_vpc.id
}
*/







