
# This section ensure that the S3 bucket is empty before it gets deleted otherwise,
# Terraform will not destroy the S3 bucket when running terraform destroy

resource "null_resource" "empty_s3_bucket" {
  provisioner "local-exec" {
    command = "aws s3 rm s3://${aws_s3_bucket.apci_jupiter_vpc_bucket.id}"
  }
  triggers = {
    bucket_name = aws_s3_bucket.apci_jupiter_vpc_bucket.id
  }
}
#### Create an S3 Bucket for the vpc flow log
resource "aws_s3_bucket" "apci_jupiter_vpc_bucket" {
  bucket = "apci-jupiter-vpc-flow-log-v5"
  force_destroy = true
  #depends_on = [ null_resource.empty_s3_bucket ]
}

############## Create a VPC flow log bucket #######################
resource "aws_flow_log" "apci_jupiter_vpc_flow_log" {
  log_destination      = aws_s3_bucket.apci_jupiter_vpc_bucket.arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = var.vpc_id
}


###   7rTH25JqkWew4Qs##