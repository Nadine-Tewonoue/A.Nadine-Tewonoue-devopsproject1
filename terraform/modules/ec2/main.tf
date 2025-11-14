# Frontend Instance (Vote + Result)
resource "aws_instance" "frontend" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [var.public_sg_id]
  key_name               = var.key_pair_name

  associate_public_ip_address = true

}

# Backend Instance (Redis + Worker)
resource "aws_instance" "backend" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet_id
  vpc_security_group_ids = [var.private_sg_id]
  key_name               = var.key_pair_name

  tags = {
    Name = "${var.project_name}-backend"
  }
}

# Database Instance (PostgreSQL)
resource "aws_instance" "database" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet_id
  vpc_security_group_ids = [var.database_sg_id]
  key_name               = var.key_pair_name

  tags = {
    Name = "${var.project_name}-database"
  }
}
