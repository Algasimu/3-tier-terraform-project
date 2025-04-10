# resource "aws_dynamodb_table" "terraform_lock" {
# #  name         = var.dynamodb_table
# name = "apci-dynamodb-table"
#   billing_mode = "PAY_PER_REQUEST"
#   hash_key     = "LockID"

#   attribute {
#     name = "LockID"
#     type = "S"
#   }

#   tags = {
#     Name = var.dynamodb_table
#     Environment = "dev"
#   }
# }
