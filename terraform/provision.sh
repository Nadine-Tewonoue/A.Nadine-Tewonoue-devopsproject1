#!/bin/bash
# ==============================================
# Terraform Provisioning Script for Nadine DevOps Project
# ==============================================

set -e  # Exit immediately on any error
set -o pipefail

PROJECT_NAME="nadine-dev"
WORK_DIR="$(pwd)"
TF_VARS_FILE="$WORK_DIR/terraform.tfvars"

echo " Starting Terraform provisioning for project: $PROJECT_NAME"
echo " Working directory: $WORK_DIR"
echo "----------------------------------------------"

# 1️⃣ Ensure Terraform is installed
if ! command -v terraform &>/dev/null; then
  echo "❌ Terraform not found! Please install Terraform first."
  exit 1
fi

# 2️⃣ Initialize Terraform
echo " Initializing Terraform..."
terraform init -input=false

# 3️⃣ Validate configuration
echo "✅ Validating Terraform configuration..."
terraform validate

# 4️⃣ Format Terraform files
echo "✨ Formatting Terraform files..."
terraform fmt -recursive

# 5️⃣ Show plan
echo " Generating Terraform plan..."
terraform plan -var-file="$TF_VARS_FILE" -out=tfplan

# 6️⃣ Apply infrastructure
echo " Applying Terraform configuration..."
terraform apply -input=false -auto-approve tfplan

# 7️⃣ Output key resources
echo " Retrieving important outputs..."
terraform output

# 8️⃣ Optional: save outputs to JSON for other scripts
terraform output -json > "$WORK_DIR/tf_output.json"
echo "💾 Saved Terraform outputs to tf_output.json"

# 9️⃣ Post-provision check
echo "🔍 Checking AWS resources..."
if command -v aws &>/dev/null; then
  aws ec2 describe-instances --filters "Name=tag:Name,Values=${PROJECT_NAME}-*" \
    --query "Reservations[*].Instances[*].{Name:Tags[?Key=='Name']|[0].Value,State:State.Name,IP:PublicIpAddress}" \
    --output table || echo "⚠️ Unable to list EC2 instances — check your AWS CLI configuration."
else
  echo "⚠️ AWS CLI not installed — skipping EC2 check."
fi

echo "✅ Terraform provisioning completed successfully!"
echo "----------------------------------------------"

