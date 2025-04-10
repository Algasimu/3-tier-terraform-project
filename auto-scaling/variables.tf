variable "vpc_id" {
  type = string 
}
variable "tags" {
  type = map(string)
}
variable "apci_jupiter_alb_sg_id" {
  type = string
}
variable "image_id" {
  type = string 
}
variable "instance_type" {
  type = string
}
variable "key_name" {
  type = string
}
variable "apci_jupiter_public_subnet_az_2a_id" {
  type = string
}
variable "apci_jupiter_public_subnet_az_2b_id" {
  type = string
}
variable "apci_jupiter_target_group_arn" {
  type = string
}