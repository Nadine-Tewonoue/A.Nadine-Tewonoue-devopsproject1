output "ami_id" {
  description = "Amazon Linux 2023 AMI ID"
  value       = data.aws_ami.amazon_linux.id
}
