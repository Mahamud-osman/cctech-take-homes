#!/bin/bash

# Setup script for Terraform infrastructure
set -e

ENVIRONMENT=${1:-dev}
REGION=${2:-us-east-1}

echo "Setting up Terraform infrastructure for environment: $ENVIRONMENT"

# # Check if AWS CLI is configured
# if ! aws sts get-caller-identity --region $REGION > /dev/null 2>&1; then
#     echo "Error: AWS CLI is not configured or credentials are invalid"
#     exit 1
# fi

# Create S3 bucket for Terraform state if it doesn't exist
STATE_BUCKET="takehome-bucket-mfo-${ENVIRONMENT}"  # Change this!
if ! aws s3 ls "s3://${STATE_BUCKET}" > /dev/null 2>&1; then
    echo "Creating S3 bucket for Terraform state: ${STATE_BUCKET}"
    aws s3 mb "s3://${STATE_BUCKET}" --region $REGION
    
    # Enable versioning
    aws s3api put-bucket-versioning \
        --bucket "${STATE_BUCKET}" \
        --versioning-configuration Status=Enabled
    
    # Enable server-side encryption
    aws s3api put-bucket-encryption \
        --bucket "${STATE_BUCKET}" \
        --server-side-encryption-configuration '{
            "Rules": [
                {
                    "ApplyServerSideEncryptionByDefault": {
                        "SSEAlgorithm": "AES256"
                    }
                }
            ]
        }'
fi

# Create DynamoDB table for state locking if it doesn't exist
LOCK_TABLE="terraform-state-lock-${ENVIRONMENT}"
if ! aws dynamodb describe-table --table-name "${LOCK_TABLE}" --region $REGION > /dev/null 2>&1; then
    echo "Creating DynamoDB table for Terraform state locking: ${LOCK_TABLE}"
    aws dynamodb create-table \
        --table-name "${LOCK_TABLE}" \
        --attribute-definitions AttributeName=LockID,AttributeType=S \
        --key-schema AttributeName=LockID,KeyType=HASH \
        --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
        --region $REGION

    echo "Waiting for DynamoDB table to be created..."
    aws dynamodb wait table-exists --table-name "${LOCK_TABLE}" --region $REGION
    echo "DynamoDB table created successfully"
else
    echo "DynamoDB table already exists: ${LOCK_TABLE}"
fi