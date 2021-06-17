resource "aws_subnet" "db_private_subnet_a" {
  vpc_id            = aws_vpc.edu_vpc.id
  cidr_block        = var.db_cidr_block_1
  availability_zone = var.az_1


  tags = {
    Name = "DB Private Subnet A"
  }
}

resource "aws_subnet" "db_private_subnet_b" {
  vpc_id            = aws_vpc.edu_vpc.id
  cidr_block        = var.db_cidr_block_2
  availability_zone = var.az_2

  tags = {
    Name = "DB Private Subnet B"
  }
}

resource "aws_subnet" "public_subnet_a" {
  vpc_id            = aws_vpc.edu_vpc.id
  cidr_block        = var.public_cidr_block_1
  availability_zone = var.az_1

  tags = {
    Name = "Public Subnet A"
  }
}

resource "aws_subnet" "public_subnet_b" {
  vpc_id            = aws_vpc.edu_vpc.id
  cidr_block        = var.public_cidr_block_2
  availability_zone = var.az_2

  tags = {
    Name = "Public Subnet B"
  }
}

resource "aws_subnet" "app_private_subnet_a" {
  vpc_id            = aws_vpc.edu_vpc.id
  cidr_block        = var.app_cidr_block_1
  availability_zone = var.az_1

  tags = {
    Name = "APP Private Subnet A"
  }
}

resource "aws_subnet" "app_private_subnet_b" {
  vpc_id            = aws_vpc.edu_vpc.id
  cidr_block        = var.app_cidr_block_2
  availability_zone = var.az_2

  tags = {
    Name = "APP Private Subnet B"
  }
}

