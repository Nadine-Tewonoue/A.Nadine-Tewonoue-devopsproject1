#!/bin/bash
# ==============================================
# Terraform Provisioning Script for Nadine DevOps Project
# ==============================================

set -e  
set -o pipefail

PROJECT_NAME="Nadine-dev"
WORK_DIR="$(pwd)"
TF_VARS_FILE="$WORK_DIR/terraform.tfvars"

echo " Starting Terraform provisioning for project: $PROJECT_NAME"
echo " Working directory: $WORK_DIR"
echo "----------------------------------------------"

# 1️-Ensure Terraform is installed
if ! command -v terraform &>/dev/null; then
  echo "❌ Terraform not found! Please install Terraform first."
  exit 1
fi

# 2️ -Initialize Terraform
echo " Initializing Terraform..."
terraform init -input=false

# 3️- Validate configuration
echo " Validating Terraform configuration..."
terraform validate

# 4️- Format Terraform files
echo " Formatting Terraform files..."
terraform fmt -recursive

terraform plan  -var-file="$TF_VARS_FILE" -out=tfplan

# 5️- Apply
terraform apply -input=false -auto-approve tfplan

echo " Retrieving important outputs..."
terraform output

# 6- Optional: save outputs to JSON for other scripts
terraform output -json > "$WORK_DIR/tf_output.json"
echo " Saved Terraform outputs to tf_output.json"

echo " Terraform provisioning completed successfully!"
echo "----------------------------------------------"

