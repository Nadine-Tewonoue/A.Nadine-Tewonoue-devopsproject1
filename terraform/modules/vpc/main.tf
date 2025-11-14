terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws"{
region = "var.aws_region"
}
resource "aws_vpc" "project1_vpc"{
cidr_block  =var.vpc_cidr
enable_dns_hostnames = true
enable_dns_support =true

tags ={
  Name ="${var.project_name}-vpc"
}

}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.project1_vpc.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = "eu-central-1a"

  tags = {
    Name = "${var.project_name}_public_subnet"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.project1_vpc.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "private-subnet"
    Name = "${var.project_name}-private-subnet"
  }
}
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
    Name = "${var.project_name}_PublicRouteTable"
  }
}
