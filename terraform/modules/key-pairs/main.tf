# Create Key Pair
resource "aws_key_pair" "main" {
  key_name   = "${project_name}-keypair"
  private_key = var.public_key

  
}

