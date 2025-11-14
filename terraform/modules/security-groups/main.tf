
# Public Security Group (for Bastion Host - Vote + Result)
resource "aws_security_group" "public" {
  name        = "${var.project_name}-public-sg"
  description = "Nadine-dev infrastructure project - Public security group for Vote and Result instances"
  vpc_id      = var.vpc_id

  # Allow HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTPS
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow SSH
  ingress {
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
    Name = "${var.project_name}-public-sg"
  }
}

# Private Security Group (for Redis + Worker)
resource "aws_security_group" "private" {
  name        = "${var.project_name}-private-sg"
  description = "nadine-dev infrastructure project - Private security group for Redis and Worker instances"
  vpc_id      = var.vpc_id

  # Allow traffic from public security group
  ingress {
    from_port       = 0
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [aws_security_group.public.id]
  }

  # Allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-private-sg"
  }
}

# Database Security Group (for PostgreSQL)
resource "aws_security_group" "database" {
  name        = "${var.project_name}-database-sg"
  description = "nadine-dev infrastructure project - Database security group for PostgreSQL"
  vpc_id      = var.vpc_id

  # Allow PostgreSQL (5432) from private security group only
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.private.id]
  }

  # Allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-database-sg"
  }
}

