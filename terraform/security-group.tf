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
  ingress {
    description = "Allow HTTP from anywhere"
    from_port   = 81
    to_port     = 81
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
  ingress {
    description     = "Allow Redis access from frontend SG"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.public_sg.id]
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

