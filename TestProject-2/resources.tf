resource "aws_vpc" "app_vpc" {
  cidr_block = "10.99.0.0/16"

  tags = {
    Name = "App VPC"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.app_vpc.id
  cidr_block        = "10.99.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Public subnet"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.app_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.app_igw.id
  }

  tags = {
    Name = "Public RT"
  }
}

resource "aws_internet_gateway" "app_igw" {
  vpc_id = aws_vpc.app_vpc.id

  tags = {
    Name = "App GW"
  }
}

resource "aws_route_table_association" "RT-IG-association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.app_vpc.id
  cidr_block        = "10.99.2.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Private subnet"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.app_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "Private RT"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = "NAT GW"
  }

  depends_on = [aws_internet_gateway.app_igw]
}

resource "aws_eip" "eip" {
  vpc = true
}

resource "aws_route_table_association" "RT-NG-association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_instance" "web_server" {
  ami                         = data.aws_ami.ubuntu_latest.id
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.web_server_sg.id]
  user_data                   = file("install_apache.sh")
  key_name                    = "edu"
  subnet_id                   = aws_subnet.public_subnet.id
  associate_public_ip_address = true

  tags = {
    Name = "Web Server"
  }
}

resource "aws_instance" "db_server" {
  ami                    = data.aws_ami.ubuntu_latest.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.db_server_sg.id]
  key_name               = "edu"
  subnet_id              = aws_subnet.private_subnet.id

  tags = {
    Name = "DB Server"
  }
}

resource "aws_instance" "jump_host" {
  ami                         = data.aws_ami.ubuntu_latest.id
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.jump_host_sg.id]
  key_name                    = "edu"
  subnet_id                   = aws_subnet.public_subnet.id
  associate_public_ip_address = true

  tags = {
    Name = "Jump Host"
  }
}


resource "aws_security_group" "web_server_sg" {
  name   = "web_server_sg"
  vpc_id = aws_vpc.app_vpc.id

  ingress {
    description = "Allow HTTP inbound traffic to server"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Web Server SG"
  }
}

resource "aws_security_group" "jump_host_sg" {
  name   = "jump_host_sg"
  vpc_id = aws_vpc.app_vpc.id

  ingress {
    description = "Allow SSH connection to server"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Jump host SG"
  }
}

resource "aws_security_group" "db_server_sg" {
  name   = "db_server_sg"
  vpc_id = aws_vpc.app_vpc.id

  ingress {
    description     = "Allow SSH connection to server from jump host"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.jump_host_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "DB Server SG"
  }
}
