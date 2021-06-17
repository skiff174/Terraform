output "vpc_id" {
  value = aws_vpc.app_vpc.id
}

output "ubuntu_latest_ami_id" {
  value = data.aws_ami.ubuntu_latest.id
}

output "web_server_id" {
  value = aws_instance.web_server.id
}

output "web_server_public_ip_addr" {
  value = aws_instance.web_server.public_ip
}
