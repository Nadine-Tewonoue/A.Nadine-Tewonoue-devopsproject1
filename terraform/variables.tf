variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "development"
}

variable "project_name" {
  description = "Project name prefix"
  type        = string
  default     = "Nadine_project1"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for private subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "public_key" {
  description = "SSH public key content"
  type        = string
}

variable "public_key-name" {
  description = "SSH public key content"
  type        = string
  default =  "project1-key-nadine.pem"
}


variable "ami_id" {
  description = "Amazon Linux 2023 AMI ID for eu-central-1"
  type        = string
  default     = "ami-089a7a2a13629ecc4"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}