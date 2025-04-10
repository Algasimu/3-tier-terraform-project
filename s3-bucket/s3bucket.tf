resource "aws_s3_bucket" "apci_jupiter_vpc_bucket" {
  bucket = "apci-jupiter-vpc-flow-log-v5"
}

# resource "aws_s3_bucket" "flow_logs_bucket" {
#   bucket = "${var.tags["project"]}-flow-logs-${var.tags["environment"]}-${random_string.suffix.result}"
#   acl    = "private"
# }

# resource "random_string" "suffix" {
#   length  = 5
#   special = false
#   upper   = true
# }

############## Create a VPC flow log bucket #######################
resource "aws_flow_log" "apci_jupiter_vpc_flow_log" {
  log_destination      = aws_s3_bucket.apci_jupiter_vpc_bucket.arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = var.vpc_id
}

