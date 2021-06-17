output "vpc_id" {
  value = aws_vpc.edu_vpc.id
}

output "db_private_subnet_a_id" {
  value = aws_subnet.db_private_subnet_a.id
}

output "db_private_subnet_b_id" {
  value = aws_subnet.db_private_subnet_b.id
}

output "public_subnet_a_id" {
  value = aws_subnet.public_subnet_a.id
}

output "public_subnet_b_id" {
  value = aws_subnet.public_subnet_b.id
}

output "app_private_subnet_a_id" {
  value = aws_subnet.app_private_subnet_a.id
}

output "app_private_subnet_b_id" {
  value = aws_subnet.app_private_subnet_b.id
}


