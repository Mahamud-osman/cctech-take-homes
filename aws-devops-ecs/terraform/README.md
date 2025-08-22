# Terraform Infrastructure for ECS Next.js Application

This directory contains the Terraform configuration for deploying a containerized Next.js application on AWS ECS with RDS PostgreSQL integration.

## Architecture Overview

The infrastructure includes:
- **VPC** with public and private subnets across 2 availability zones
- **ECS Cluster** using Fargate launch type
- **RDS PostgreSQL** instance in private subnets
- **Application Load Balancer** for traffic distribution
- **ECR Repository** for Docker image storage
- **Secrets Manager** for secure credential management
- **Security Groups** with least privilege access

## Prerequisites

1. **AWS CLI** configured with appropriate credentials
2. **Terraform** version >= 1.0
3. **Docker** for building and pushing images to ECR

## Quick Start

### 1. Initialize Terraform
```bash
terraform init
```

### 2. Review the plan
```bash
terraform plan
```

### 3. Apply the infrastructure
```bash
terraform apply
```

### 4. Destroy infrastructure (when done)
```bash
terraform destroy
```

## Configuration

### Variables
All configurable values are defined in `variables.tf` with sensible defaults. You can override them by:

1. Creating a `terraform.tfvars` file (not tracked in git)
2. Using command line flags: `terraform apply -var="app_count=3"`
3. Using environment variables: `export TF_VAR_app_count=3`

### Important Variables
- `aws_region`: AWS region for deployment (default: us-east-1)
- `environment`: Environment name (default: dev)
- `app_count`: Number of ECS tasks (default: 2)
- `db_instance_class`: RDS instance type (default: db.t3.micro)

## State Management

For production use, configure remote state storage by uncommenting and configuring the backend in `main.tf`:

```hcl
backend "s3" {
  bucket         = "your-terraform-state-bucket"
  key            = "ecs-app/terraform.tfstate"
  region         = "us-east-1"
  dynamodb_table = "terraform-state-lock"
  encrypt        = true
}
```

## Security Considerations

- RDS instance is deployed in private subnets
- Security groups follow least privilege principle
- Database credentials are stored in AWS Secrets Manager
- All resources are tagged for cost tracking and management

## Outputs

After successful deployment, Terraform will output:
- ALB DNS name for accessing the application
- ECR repository URL for pushing Docker images
- RDS endpoint (sensitive)
- Various resource IDs for reference

## Troubleshooting

### Common Issues
1. **VPC CIDR conflicts**: Ensure the VPC CIDR doesn't conflict with existing VPCs
2. **Subnet CIDR conflicts**: Verify subnet CIDRs are within VPC range and don't overlap
3. **IAM permissions**: Ensure your AWS credentials have sufficient permissions

### Useful Commands
```bash
# View outputs
terraform output

# View specific output
terraform output alb_dns_name

# Refresh state
terraform refresh

# Import existing resources (if needed)
terraform import aws_vpc.main vpc-12345
```

## Cost Optimization

- Use `db.t3.micro` for development (upgrade for production)
- Consider using Fargate Spot for non-critical workloads
- Monitor resource usage and adjust instance sizes accordingly
- Use ECR lifecycle policies to clean up old images

## Next Steps

After infrastructure deployment:
1. Build and push the Docker image to ECR
2. Update the ECS task definition with the new image
3. Set up CI/CD pipeline for automated deployments
4. Configure monitoring and logging 