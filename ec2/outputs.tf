output "apci_jupiter_bastion_sg" {
  value = aws_security_group.apci_jupiter_bastion_sg.id
}
output "apci_jupiter_private_server_sg" {
  value = aws_security_group.apci_jupiter_private_server_sg.id
}