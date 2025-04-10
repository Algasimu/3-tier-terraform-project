output "vpc_id" {
  value = aws_vpc.apci_jupiter_main_vpc.id
}
output "apci_jupiter_public_subnet_az_2a_id" {
  value = aws_subnet.apci_jupiter_public_subnet_az_2a.id
}
output "apci_jupiter_public_subnet_az_2b_id" {
  value = aws_subnet.apci_jupiter_public_subnet_az_2b.id
}
output "apci_jupiter_db_subnet_az_2a" {
  value = aws_subnet.apci_jupiter_db_subnet_az_2a.id
}
output "apci_jupiter_db_subnet_az_2b" {
  value = aws_subnet.apci_jupiter_db_subnet_az_2b.id
}
output "apci_jupiter_private_subnet_az_2a" {
  value = aws_subnet.apci_jupiter_private_subnet_az_2a.id
}
output "apci_jupiter_private_subnet_az_2b" {
  value = aws_subnet.apci_jupiter_private_subnet_az_2b.id
}