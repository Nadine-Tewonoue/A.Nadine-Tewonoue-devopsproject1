# Hard-coded Amazon Linux 2023 AMI for eu-central-1
locals {
  ami_id = "ami-089a7a2a13629ecc4"
}

# Output the AMI ID
data "aws_ami" "amazon_linux" {
  filter {
    name   = "image-id"
    values = [local.ami_id]
  }
}
