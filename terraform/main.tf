terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

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

# ----------------------------------------------------------------------
# Internet Gateway and Route Table
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

# ----------------------------------------------------------------------
#  Public SG (Frontend / Vote + Result)
# ----------------------------------------------------------------------
resource "aws_security_group" "public_sg" {
  name        = "${var.project_name}-public-sg"
  description = "Allow HTTP/HTTPS/SSH from the internet"
  vpc_id      = aws_vpc.project1_vpc.id

  # Allow HTTP
  ingress {
    description = "Allow HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTPS
  ingress {
    description = "Allow HTTPS from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow SSH from anywhere (or limit to your IP)
  ingress {
    description = "Allow SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Vote-Public-SG"
  }
}

# ----------------------------------------------------------------------
# 2️⃣ Private SG (Backend / Worker)
# ----------------------------------------------------------------------
resource "aws_security_group" "private_sg" {
  name        = "${var.project_name}-private-sg"
  description = "Allow traffic from frontend SG and outbound access"
  vpc_id      = aws_vpc.project1_vpc.id

  # Allow Redis access from frontend
  ingress {
    description     = "Allow Redis access from frontend SG"
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [aws_security_group.public_sg.id]
  }

  # Allow SSH from frontend
  ingress {
    description     = "Allow SSH from frontend SG"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.public_sg.id]
  }

  # Allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Backend-Private-SG"
  }
}

# ----------------------------------------------------------------------
# 3️⃣ Database SG (PostgreSQL)
# ----------------------------------------------------------------------
resource "aws_security_group" "database_sg" {
  name        = "${var.project_name}-database-sg"
  description = "Allow PostgreSQL only from private SG and SSH from frontend"
  vpc_id      = aws_vpc.project1_vpc.id

  # Allow PostgreSQL from private SG
  ingress {
    description     = "Allow PostgreSQL from private SG"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.private_sg.id]
  }

  # Optional: Allow SSH from frontend SG
  ingress {
    description     = "Allow SSH from frontend SG"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.public_sg.id]
  }

  # Allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Database-SG"
  }
}


# ----------------------------------------------------------------------
# EC2 Instances
# ----------------------------------------------------------------------

# A - Frontend Instance (Vote + Result)
resource "aws_instance" "frontend" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.public_sg.id]
  key_name               = var.key_pair_name

  associate_public_ip_address = true

  tags = {
    Name = "${var.project_name}-frontend"
  }
}

# B - Backend Instance (Redis + Worker)
resource "aws_instance" "backend" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private_subnet.id
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  key_name               = var.key_pair_name

  tags = {
    Name = "${var.project_name}-backend"
  }
}

# C - Database Instance (PostgreSQL)
resource "aws_instance" "database" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private_subnet.id
  vpc_security_group_ids = [aws_security_group.database_sg.id]
  key_name               = var.key_pair_name

  tags = {
    Name = "${var.project_name}-database"
  }
}

# ----------------------------------------------------------------------
# OUTPUTS
# ----------------------------------------------------------------------

output "vpc_id" {
  value = aws_vpc.project1_vpc.id
}

output "public_subnet_id" {
  value = aws_subnet.public_subnet.id
}

output "private_subnet_id" {
  value = aws_subnet.private_subnet.id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.igw.id
}

output "frontend_public_ip" {
  description = "Public IP address of the frontend (Vote/Result) instance"
  value       = aws_instance.frontend.public_ip
}

output "backend_private_ip" {
  description = "Private IP address of the backend (Redis + Worker) instance"
  value       = aws_instance.backend.private_ip
}


output "database_private_ip" {
  description = "Private IP address of the database (PostgreSQL) instance"
  value       = aws_instance.database.private_ip
}




