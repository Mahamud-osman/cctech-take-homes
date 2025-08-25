# DevSecOps Engineer Assessment: Containerized Next.js Application with RDS


## Overview
This assessment evaluates your DevSecOps skills, focusing on infrastructure as code, containerization, database integration, security implementation, and CI/CD pipeline setup. You'll deploy a provided Next.js application in a secure, scalable containerized architecture using Terraform and AWS services, including RDS PostgreSQL integration.

## Project URL
http://my-takehome-project-dev-alb-v2-237239594.us-east-1.elb.amazonaws.com/




### Section 1: Infrastructure Architecture
- Deployed containerized Next.js application using AWS ECS with Fargate launch type for serverless container orchestration
- Configured Application Load Balancer with health checks to distribute traffic across multiple availability zones
- Separated infrastructure into modular Terraform files (networking.tf, compute.tf, database.tf) for maintainability and reusability

### Section 2: Network Configuration
- Created VPC with 2 public and 2 private subnets across us-east-1a and us-east-1b availability zones for high availability
- Implemented NAT Gateway in public subnet to enable secure outbound internet access for private resources
- Established security groups with granular rules allowing only necessary traffic between application, database, and load balancer tiers

### Section 3: Container Management
- Built and pushed Docker image to AWS ECR repository with automated versioning using GitHub commit SHA tags
- Configured ECS task definition with environment variables sourced from AWS Secrets Manager for secure credential handling
- Set up ECS service with desired count of 2 tasks and rolling deployment strategy for zero-downtime updates

### Section 4: Database Integration
- Provisioned RDS PostgreSQL instance in private subnets with automated backups and encryption at rest
- Created database subnet group spanning multiple AZs and implemented security group restricting access to ECS tasks only
- Integrated Secrets Manager to securely store database credentials and configured application to retrieve them at runtime

### Section 5: Security Implementation
- Applied principle of least privilege with IAM roles for ECS tasks, allowing only necessary permissions for Secrets Manager and ECR access
- Enabled VPC Flow Logs and configured security groups with specific port access (80 for ALB, 5432 for PostgreSQL, 3000 for application)
- Implemented HTTPS-ready infrastructure with SSL certificate support and encrypted communication between all AWS services

## Deployment Instructions

### Prerequisites
- AWS CLI configured with appropriate permissions
- Terraform installed (version 1.0 or higher)
- Docker installed and running
- Git repository access

### Step 1: Clone and Setup
```bash
git clone <your-repository-url>
cd aws-devops-ecs
```

### Step 2: Configure AWS Credentials
```bash
aws configure
# Enter your AWS Access Key ID, Secret Access Key, and region (us-east-1)
```

### Step 3: Initialize Terraform
```bash
cd terraform
terraform init
```

### Step 4: Deploy Infrastructure
```bash
terraform plan
terraform apply
# Type 'yes' when prompted to confirm deployment
```

### Step 5: Build and Push Docker Image
```bash
# Get ECR login token
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <account-id>.dkr.ecr.us-east-1.amazonaws.com

# Build and tag the image
docker build -t my-takehome-project ./app
docker tag my-takehome-project:latest <account-id>.dkr.ecr.us-east-1.amazonaws.com/my-takehome-project:latest

# Push to ECR
docker push <account-id>.dkr.ecr.us-east-1.amazonaws.com/my-takehome-project:latest
```

### Step 6: Access Application
After deployment completes, access your application using the ALB DNS name provided in Terraform output:
```
http://<alb-dns-name>
```

### Cleanup
To destroy all resources:
```bash
terraform destroy
# Type 'yes' when prompted to confirm destruction
```
