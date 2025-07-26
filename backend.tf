terraform {
  backend "s3" {
    bucket = "state-s3bucket01"
    key    = "env/dev/terraform.tfstate"
    region = "us-east-2"
    dynamodb_table = "state-terraform-db"
  }
}
