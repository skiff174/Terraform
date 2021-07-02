resource "aws_vpc" "ppln_vpc" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "PPLN VPC"
  }
}

resource "aws_route_table" "ppln_public_rt" {
  vpc_id = aws_vpc.ppln_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ppln_igw.id
  }

  tags = {
    Name = "PPLN Public RT"
  }
}

resource "aws_internet_gateway" "ppln_igw" {
  vpc_id = aws_vpc.ppln_vpc.id

  tags = {
    Name = "PPLN IGW"
  }
}

resource "aws_default_network_acl" "ppln_nacl" {
  default_network_acl_id = aws_vpc.ppln_vpc.default_network_acl_id

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 101
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 102
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 22
    to_port    = 22
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 103
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  tags = {
    Name = "PPLN_NACL"
  }
}

resource "aws_route_table_association" "ppln_bastion_host_rt_1" {
  subnet_id      = aws_subnet.bastion_host_subnet_a.id
  route_table_id = aws_route_table.ppln_public_rt.id
}

resource "aws_route_table_association" "ppln_bastion_host_rt_2" {
  subnet_id      = aws_subnet.bastion_host_subnet_b.id
  route_table_id = aws_route_table.ppln_public_rt.id
}

resource "aws_route_table_association" "ppln_webserver_rt_1" {
  subnet_id      = aws_subnet.webserver_subnet_a.id
  route_table_id = aws_route_table.ppln_public_rt.id
}

resource "aws_route_table_association" "ppln_webserver_rt_2" {
  subnet_id      = aws_subnet.webserver_subnet_b.id
  route_table_id = aws_route_table.ppln_public_rt.id
}

