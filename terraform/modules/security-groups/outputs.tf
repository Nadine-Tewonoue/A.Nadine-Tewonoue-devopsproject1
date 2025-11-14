output "public_sg_id" {
  description = "Public security group ID"
  value       = aws_security_group.public.id
}

output "private_sg_id" {
  description = "Private security group ID"
  value       = aws_security_group.private.id
}

output "database_sg_id" {
  description = "Database security group ID"
  value       = aws_security_group.database.id
}
