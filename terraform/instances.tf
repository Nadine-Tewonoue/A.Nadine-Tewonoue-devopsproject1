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
