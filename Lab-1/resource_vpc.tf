resource "aws_vpc" "edu_vpc" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "Edu VPC"
  }
}

resource "aws_route_table" "edu_public_rt" {
  vpc_id = aws_vpc.edu_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.edu_igw.id
  }

  tags = {
    Name = "Edu Public RT"
  }
}

resource "aws_internet_gateway" "edu_igw" {
  vpc_id = aws_vpc.edu_vpc.id

  tags = {
    Name = "Edu IGW"
  }
}

resource "aws_route_table" "edu_private_rt_a" {
  vpc_id = aws_vpc.edu_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.edu_nat_gw_a.id
  }

  tags = {
    Name = "Edu Private RT A"
  }
}

resource "aws_route_table" "edu_private_rt_b" {
  vpc_id = aws_vpc.edu_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.edu_nat_gw_b.id
  }

  tags = {
    Name = "Edu Private RT B"
  }
}

resource "aws_nat_gateway" "edu_nat_gw_a" {
  allocation_id = aws_eip.eip_a.id
  subnet_id     = aws_subnet.public_subnet_a.id

  tags = {
    Name = "Edu NAT GW A"
  }

  depends_on = [aws_internet_gateway.edu_igw]
}

resource "aws_nat_gateway" "edu_nat_gw_b" {
  allocation_id = aws_eip.eip_b.id
  subnet_id     = aws_subnet.public_subnet_b.id

  tags = {
    Name = "Edu NAT GW B"
  }

  depends_on = [aws_internet_gateway.edu_igw]
}

resource "aws_eip" "eip_a" {
  vpc = true
}

resource "aws_eip" "eip_b" {
  vpc = true
}

resource "aws_route_table_association" "edu_public_rt_1" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.edu_public_rt.id
}

resource "aws_route_table_association" "edu_public_rt_2" {
  subnet_id      = aws_subnet.public_subnet_b.id
  route_table_id = aws_route_table.edu_public_rt.id
}

resource "aws_route_table_association" "edu_private_rt_a" {
  subnet_id      = aws_subnet.app_private_subnet_a.id
  route_table_id = aws_route_table.edu_private_rt_a.id
}

resource "aws_route_table_association" "edu_private_rt_b" {
  subnet_id      = aws_subnet.app_private_subnet_b.id
  route_table_id = aws_route_table.edu_private_rt_b.id
}

