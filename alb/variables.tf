variable "vpc_id" {
  type = string
}
variable "tags" {
  type = map(string)
}
variable "apci_jupiter_public_subnet_az_2a_id" {
  type = string
}
variable "apci_jupiter_public_subnet_az_2b_id" {
  type = string
}
variable "ssl_policy" {
  type = string
}
variable "certificate_arn" {
  type = string
}