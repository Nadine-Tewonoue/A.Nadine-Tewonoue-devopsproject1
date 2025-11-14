variable "project_name" {
  description = "Project name prefix"
  type        = string
  default="Nadine_project1"
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}