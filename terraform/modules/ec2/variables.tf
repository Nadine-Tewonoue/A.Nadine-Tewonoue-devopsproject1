variable "project_name" {
  description = "Project name prefix"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "public_subnet_id" {
  description = "Public subnet ID for frontend instance"
  type        = string
}

variable "private_subnet_id" {
  description = "Private subnet ID for backend and database instances"
  type        = string
}

variable "public_sg_id" {
  description = "Public security group ID"
  type        = string
}

variable "private_sg_id" {
  description = "Private security group ID"
  type        = string
}

variable "database_sg_id" {
  description = "Database security group ID"
  type        = string
}


variable "key_pair_name" {
  description = "SSH public key content"
  type        = string
  default =  "project1-key-nadine.pem "
}