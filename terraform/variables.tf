variable "aws_region" {
  description = "AWS region"
  type        = string
  
}

variable "environment" {
  description = "Environment name"
  type        = string
  
}
variable "availability_zone" {
  description = "AWS availability zone for subnet placement"
  type        = string
  
}

variable "project_name" {
  description = "Project name prefix"
  type        = string

}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  
}

variable "public_subnet_id" {
  description = "CIDR block for public subnet"
  type        = string

}

variable "private_subnet_id" {
  description = "CIDR block for private subnet"
  type        = string
  
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
  
}
