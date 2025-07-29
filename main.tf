# Configure the AWS Provider
provider "aws" {
  region = var.region
}

# terraform {
#   backend "s3" {
#     bucket         = "apci-devsecops-project-bucket"  # Replace with your bucket name
#     key            = "apci/state/terraform.tfstate"  # File path inside the bucket
#     region         = "us-east-2"  # Change to your region
#     dynamodb_table = "apci-devsecops-project-lock-table"  # Name of DynamoDB table for locking
#     encrypt        = true  # Encrypt state file
#   }
# }

module "vpc" {
  source                    = "./vpc"
  vpc_cidr_block            = var.vpc_cidr_block
  tags                      = local.project_tags
  public_subnet_cidr_block  = var.public_subnet_cidr_block
  private_subnet_cidr_block = var.private_subnet_cidr_block
  availability_zone         = var.availability_zone
}
module "alb" {
  source                              = "./alb"
  apci_jupiter_public_subnet_az_2a_id = module.vpc.apci_jupiter_public_subnet_az_2a_id
  apci_jupiter_public_subnet_az_2b_id = module.vpc.apci_jupiter_public_subnet_az_2b_id
  vpc_id                              = module.vpc.vpc_id
  tags                                = local.project_tags
  ssl_policy                          = var.ssl_policy
  certificate_arn                     = var.certificate_arn
}

module "auto-scaling" {
  source                              = "./auto-scaling"
  tags                                = local.project_tags
  apci_jupiter_alb_sg_id              = module.alb.apci_jupiter_alb_sg_id
  vpc_id                              = module.vpc.vpc_id
  image_id                            = var.image_id
  instance_type                       = var.instance_type
  key_name                            = var.key_name
  apci_jupiter_public_subnet_az_2a_id = module.vpc.apci_jupiter_public_subnet_az_2a_id
  apci_jupiter_public_subnet_az_2b_id = module.vpc.apci_jupiter_public_subnet_az_2b_id
  apci_jupiter_target_group_arn       = module.alb.apci_jupiter_target_group_arn
}

module "route53" {
  source                    = "./route53"
  apci_jupiter_alb_dns_name = module.alb.apci_jupiter_alb_dns_name
  apci_jupiter_alb_zone_id  = module.alb.apci_jupiter_alb_zone_id
  dns_name                  = var.dns_name
  zone_id                   = var.zone_id
}

module "rds" {
  source                         = "./rds"
  apci_jupiter_db_subnet_az_2b   = module.vpc.apci_jupiter_db_subnet_az_2b
  apci_jupiter_db_subnet_az_2a   = module.vpc.apci_jupiter_db_subnet_az_2a
  tags                           = local.project_tags
  region                         = var.region
  parameter_group_name           = var.parameter_group_name
  vpc_cidr_block                 = var.vpc_cidr_block
  vpc_id                         = module.vpc.vpc_id
  account_id                     = var.account_id
  db_username                    = var.db_username
  instance_class                 = var.instance_class
  engine_version                 = var.engine_version
  apci_jupiter_bastion_sg        = module.ec2.apci_jupiter_bastion_sg
  apci_jupiter_private_server_sg = module.ec2.apci_jupiter_private_server_sg
}

module "ec2" {
  source                              = "./ec2"
  image_id                            = var.image_id
  instance_type                       = var.instance_type
  apci_jupiter_public_subnet_az_2a_id = module.vpc.apci_jupiter_public_subnet_az_2a_id
  key_name                            = var.key_name
  tags                                = local.project_tags
  apci_jupiter_private_subnet_az_2a   = module.vpc.apci_jupiter_private_subnet_az_2a
  apci_jupiter_private_subnet_az_2b   = module.vpc.apci_jupiter_private_subnet_az_2b
  vpc_id                              = module.vpc.vpc_id
}
module "s3bucket" {
  source = "./s3-bucket"
  vpc_id = module.vpc.vpc_id
}
