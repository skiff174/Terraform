resource "aws_subnet" "webserver_subnet_a" {
  vpc_id            = aws_vpc.ppln_vpc.id
  cidr_block        = var.webserver_cidr_block_1
  availability_zone = var.az_1


  tags = {
    Name = "Webserver Subnet A"
  }
}

resource "aws_subnet" "webserver_subnet_b" {
  vpc_id            = aws_vpc.ppln_vpc.id
  cidr_block        = var.webserver_cidr_block_2
  availability_zone = var.az_2

  tags = {
    Name = "Webserver Subnet B"
  }
}

resource "aws_subnet" "bastion_host_subnet_a" {
  vpc_id            = aws_vpc.ppln_vpc.id
  cidr_block        = var.bastion_host_cidr_block_1
  availability_zone = var.az_1

  tags = {
    Name = "Bastion host Subnet A"
  }
}

resource "aws_subnet" "bastion_host_subnet_b" {
  vpc_id            = aws_vpc.ppln_vpc.id
  cidr_block        = var.bastion_host_cidr_block_2
  availability_zone = var.az_2

  tags = {
    Name = "Bastion host Subnet B"
  }
}


