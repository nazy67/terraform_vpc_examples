# VPC
resource "aws_vpc" "my_vpc" {
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = var.instance_tenancy
  enable_dns_support   = var.is_enabled_dns_support
  enable_dns_hostnames = var.is_enabled_dns_hostnames
  tags = merge(
    local.common_tags,
    {
      Name = "${var.env}_vpc"
    }
  )
}

# Public Subnets
resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.pub_cidr1_subnet
  availability_zone = var.aws_az_1a
  tags = merge(
    local.common_tags,
    {
      Name = "${var.env}_pub_sub1"
    }
  )
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.pub_cidr2_subnet
  availability_zone = var.aws_az_1b
  tags = merge(
    local.common_tags,
    {
      Name = "${var.env}_pub_sub2"
    }
  )
}

resource "aws_subnet" "public_subnet_3" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.pub_cidr3_subnet
  availability_zone = var.aws_az_1c
  tags = merge(
    local.common_tags,
    {
      Name = "${var.env}_pub_sub3"
    }
  )
}

# Private Subnets
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.priv_cidr1_subnet
  availability_zone = var.aws_az_1a
  tags = merge(
    local.common_tags,
    {
      Name = "${var.env}_priv_sub1"
    }
  )
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.priv_cidr2_subnet
  availability_zone = var.aws_az_1b
  tags = merge(
    local.common_tags,
    {
      Name = "${var.env}_priv_sub2"
    }
  )
}

resource "aws_subnet" "private_subnet_3" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.priv_cidr3_subnet
  availability_zone = var.aws_az_1c
  tags = merge(
    local.common_tags,
    {
      Name = "${var.env}_priv_sub3"
    }
  )
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = merge(
    local.common_tags,
    {
      Name = "${var.env}_igw"
    }
  )
}

# Public Route Table
resource "aws_route_table" "pub_rtb" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = var.cidr_block
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${var.env}_pub_rtb"
    }
  )
}

# Public Route Table Association
resource "aws_route_table_association" "pub_sub1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.pub_rtb.id
}

resource "aws_route_table_association" "pub_sub2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.pub_rtb.id
}

resource "aws_route_table_association" "pub_sub3" {
  subnet_id      = aws_subnet.public_subnet_3.id
  route_table_id = aws_route_table.pub_rtb.id
}

# Elastic IP
resource "aws_eip" "nat_gw_eip" {
  vpc = true
  tags = merge(
    local.common_tags,
    {
      Name = "${var.env}_eip"
    }
  )
}

# Nat Gateway
resource "aws_nat_gateway" "nat_gw" {
  depends_on    = [aws_internet_gateway.igw]
  allocation_id = aws_eip.nat_gw_eip.id
  subnet_id     = aws_subnet.public_subnet_1.id
  tags = merge(
    local.common_tags,
    {
      Name = "${var.env}_nat_gw"
    }
  )
}

# Private Route Table
resource "aws_route_table" "private_rtb" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block     = var.cidr_block
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
  tags = merge(
    local.common_tags,
    {
      Name = "${var.env}_private_rtb"
    }
  )
}

# Private Route Table Association
resource "aws_route_table_association" "priv_sub1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_rtb.id
}

resource "aws_route_table_association" "priv_sub2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_rtb.id
}

resource "aws_route_table_association" "priv_sub3" {
  subnet_id      = aws_subnet.private_subnet_3.id
  route_table_id = aws_route_table.private_rtb.id
}