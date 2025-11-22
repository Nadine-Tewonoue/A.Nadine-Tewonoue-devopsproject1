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
output "private_subnet2_id" {
  value = aws_subnet.private_subnet2.id
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


