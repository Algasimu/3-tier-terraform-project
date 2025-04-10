
## The aws_db_subnet_group is used to define a collection of 
##subnets within a Virtual Private Cloud (VPC) where an Amazon RDS 
##(Relational Database Service) instance can be deployed.

resource "aws_db_subnet_group" "apci_jupiter_db_subnet_group" {
  name       = "apci-jupiter-db-subnet-group"
  subnet_ids = [var.apci_jupiter_db_subnet_az_2a, var.apci_jupiter_db_subnet_az_2b]

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-db-subnet-group"
  })
}

### Creating RDS security group.This is for the backend 
resource "aws_security_group" "apci_jupiter_rds_sg" {
  name        = "rds-sg"
  description = "Allow allow DB traffic"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-rds-sg"
  })
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.apci_jupiter_rds_sg.id  
  referenced_security_group_id = var.apci_jupiter_private_server_sg
  #referenced_security_group_id = var.apci_jupiter_bastion_sg # This means that you can connect to the rds server by only using the bastion host
  from_port         = 3306  ### this is the port of the default port used by MySQL DB
  ip_protocol       = "tcp"
  to_port           = 3306 
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.apci_jupiter_rds_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

data "aws_secretsmanager_secret" "apci_jupiter_rdsmysql" {
  name ="rdsmysql2"
}
data "aws_secretsmanager_secret_version" "apci_jupiter_secret_version" {
  secret_id = data.aws_secretsmanager_secret.apci_jupiter_rdsmysql.id
}

### Create RDS Secret Manager IAM role
/*resource "aws_iam_role" "rds_secrets_manager_role" {
  name = "rds-secrets-manager-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "rds.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "secrets_manager_policy" {
  name        = "rds-secrets-manager-policy"
  description = "Policy to allow RDS to access Secrets Manager"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Resource = "arn:aws:secretsmanager:${var.region}:${var.account_id}:secret:rdsmysql2-*" # Make changes here
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_secrets_manager_policy" {
  role       = aws_iam_role.rds_secrets_manager_role.name
  policy_arn = aws_iam_policy.secrets_manager_policy.arn
}
*/
### Create an RDS MySql instance
resource "aws_db_instance" "apci_jupiter_mydb" {
  allocated_storage    = 10
  db_name              = "mydb"
  engine               = "mysql"
  #identifier          = 
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  username             = var.db_username
  password             = jsondecode(data.aws_secretsmanager_secret_version.apci_jupiter_secret_version.secret_string)["password"]
  parameter_group_name = var.parameter_group_name
  vpc_security_group_ids = [aws_security_group.apci_jupiter_rds_sg.id]
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.apci_jupiter_db_subnet_group.name
}
