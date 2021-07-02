output "vpc_id" {
  value = aws_vpc.ppln_vpc.id
}

output "webserver_subnet_a_id" {
  value = aws_subnet.webserver_subnet_a.id
}

output "webserver_subnet_b_id" {
  value = aws_subnet.webserver_subnet_b.id
}

output "bastion_host_subnet_a_id" {
  value = aws_subnet.bastion_host_subnet_a.id
}

output "bastion_host_subnet_b_id" {
  value = aws_subnet.bastion_host_subnet_b.id
}



