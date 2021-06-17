output "vpc_id" {
  value = aws_vpc.edu_vpc.id
}

output "subnet_db_layer_1_private_id" {
  value = aws_subnet.db_private_subnet_a.id
}

output "subnet_db_layer_2_private_id" {
  value = aws_subnet.db_private_subnet_b.id
}

output "subnet_dmz_1_public_id" {
  value = aws_subnet.public_subnet_a.id
}

output "subnet_dmz_2_public_id" {
  value = aws_subnet.public_subnet_b.id
}

output "subnet_app_layer_1_private_id" {
  value = aws_subnet.app_private_subnet_a.id
}

output "subnet_app_layer_2_private_id" {
  value = aws_subnet.app_private_subnet_b.id
}


