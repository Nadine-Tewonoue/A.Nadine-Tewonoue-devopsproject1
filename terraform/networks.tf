# ----------------------------------------------------------------------
# VPC
# ----------------------------------------------------------------------

resource "aws_vpc" "project1_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# ----------------------------------------------------------------------
# Subnets
# ----------------------------------------------------------------------

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.project1_vpc.id
  cidr_block              = var.public_subnet_id
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zone

  tags = {
    Name = "${var.project_name}-public-subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.project1_vpc.id
  cidr_block        = var.private_subnet_id
  availability_zone = var.availability_zone

  tags = {
    Name = "${var.project_name}-private-subnet"
  }
}
resource "aws_subnet" "private_subnet2" {
  vpc_id            = aws_vpc.project1_vpc.id
  cidr_block        = var.private_subnet2_id
  availability_zone = var.availability_zone2

  tags = {
    Name = "${var.project_name}-private-subnet2"
  }
}

# ----------------------------------------------------------------------
# descriptiony    ^^<.n j. -bv.b. .n.b.cäc.
# ----------------------------------------------------------------------

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.project1_vpc.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.project1_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.project_name}-public-rt"
  }
}


resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}
resource "aws_eip" "nat_eip" {
  vpc = true
}
resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id
  tags          = { Name = "project1-nat-gateway" }
  depends_on    = [aws_internet_gateway.igw]

}


resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.project1_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw.id
  }
  tags = { Name = "project1-private-route-table" }
}

resource "aws_route_table_association" "private_1_assoc" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}
resource "aws_route_table_association" "private_2_assoc" {
  subnet_id      = aws_subnet.private_subnet2.id
  route_table_id = aws_route_table.private_rt.id
}
