# resource "aws_default_vpc" "default" {
#   tags = {
#     Name = "Default VPC"
#   }
# }

resource "aws_vpc" "team1_vpc" {
  cidr_block       = var.vpc_cidr_block

  tags = {
    Name = "team1_vpc"
  }
}

resource "aws_subnet" "team1_publicsubnet" {
  vpc_id     = aws_vpc.team1_vpc.id
  cidr_block = var.public_subnet_cidr_block
  map_public_ip_on_launch = true


  tags = {
    Name = "team1_publicsubnet"
  }
}

resource "aws_subnet" "team1_privatesubnet" {
  vpc_id     = aws_vpc.team1_vpc.id
  cidr_block = var.private_subnet_cidr_block
  map_public_ip_on_launch = false

  tags = {
    Name = "team1_privatesubnet"
  }
}

resource "aws_route_table" "team1_routetable_public" {
  vpc_id = aws_vpc.team1_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.team1_gw.id
  }

  tags = {
    Name = "team1_routetable_public"
  }
}

resource "aws_route_table" "team1_routetable_private" {
  vpc_id = aws_vpc.team1_vpc.id

  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = "local"
  }

  tags = {
    Name = "team1_routetable_private"
  }
}

resource "aws_internet_gateway" "team1_gw" {
  vpc_id = aws_vpc.team1_vpc.id

  tags = {
    Name = "team1_gw"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.team1_publicsubnet.id
  route_table_id = aws_route_table.team1_routetable_public.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.team1_privatesubnet.id
  route_table_id = aws_route_table.team1_routetable_private.id
}