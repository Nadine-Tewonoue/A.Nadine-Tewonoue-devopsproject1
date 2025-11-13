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
variable "availability_zone" {
  description = "AWS availability zone for subnet placement"
  type        = string
  default     = "eu-central-1"
}

variable "project_name" {
  description = "Project name prefix"
  type        = string
  default     = "Nadine_dev"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_id" {
  description = "CIDR block for public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_id" {
  description = "CIDR block for private subnet"
  type        = string
  default     = "10.0.2.0/24"
}



variable "key_pair_name" {
  description = "SSH public key content"
  type        = string

}


variable "ami_id" {
  description = "Amazon Linux 2023 AMI ID for eu-central-1"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}
variable "my_ip" {
  description = "ssh puplic ip"
  type        = string
}