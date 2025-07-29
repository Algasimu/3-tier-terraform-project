vpc_cidr_block            = "10.0.0.0/16"
public_subnet_cidr_block  = ["10.0.0.0/24", "10.0.1.0/24"]
private_subnet_cidr_block = ["10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24"]
availability_zone         = ["us-east-2a", "us-east-2b"] #This available zone are in the Ohio region 
ssl_policy                = "ELBSecurityPolicy-2016-08"
certificate_arn           = "arn:aws:acm:us-east-2:156041418844:certificate/64ce5192-6761-4b57-90dc-3c88b92f3c82"
image_id                  = "ami-0fc82f4dabc05670b"
instance_type             = "t2.micro"
key_name                  = "myKey"
zone_id                   = "Z070127329PP14SZP42WO"
dns_name                  = "hijab1.prettymariashop.com"
region                    = "us-east-2"
account_id                = "156041418844"
engine_version            = "8.0"
instance_class            = "db.t3.micro"
db_username               = "admin"
parameter_group_name      = "default.mysql8.0"

