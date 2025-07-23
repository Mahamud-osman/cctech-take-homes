# DevSecOps Engineer Assessment: Containerized Next.js Application with RDS

## Overview
This assessment evaluates your DevSecOps skills, focusing on infrastructure as code, containerization, database integration, security implementation, and CI/CD pipeline setup. You'll deploy a provided Next.js application in a secure, scalable containerized architecture using Terraform and AWS services, including RDS PostgreSQL integration.

## Challenge Requirements
1. Use Terraform for all infrastructure provisioning
2. Deploy the provided Next.js application on AWS ECS (Elastic Container Service) with Fargate launch type
3. Use AWS ECR (Elastic Container Registry) for storing the application's Docker image
4. Set up an RDS instance running PostgreSQL and integrate it with the application
5. Implement AWS Secrets Manager for secure credential management
6. Set up a CI/CD pipeline using GitHub Actions (This does NOT need to be in Terraform)

## Provided Resources
- A GitHub repository containing a simple Next.js application with:
  * A pre-configured Dockerfile
  * Sample environment variable configuration for database connection
  * Basic database query functionality to demonstrate connectivity

## Functionality to Implement

### 1. Networking (using Terraform)
- Create a VPC with two public and two private subnets across two availability zones
- Set up an Internet Gateway and NAT Gateways for internet connectivity
- Configure appropriate route tables

### 2. Compute and Containers (using Terraform)
- Create an ECS cluster using Fargate launch type
- Set up an ECR repository for the application image

### 3. Database Setup (using Terraform)
- Provision an RDS instance running PostgreSQL in the private subnets
- Configure appropriate security groups to allow traffic only from the application's security group
- Use AWS Secrets Manager to store the database credentials

### 4. Application Deployment and Database Integration
- Push the provided application's Docker image to ECR
- Create an ECS task definition and service to run the application
- Configure the ECS task to use environment variables for database connection, retrieving credentials from AWS Secrets Manager
- Ensure the application can successfully connect to the RDS instance
- Make the application accessible through an Application Load Balancer on port 80

### 5. Security Implementation
- Implement IAM roles following the principle of least privilege
- Secure all network traffic using appropriate security groups
- Ensure secure transmission of database credentials from Secrets Manager to the application

### 6. CI/CD Pipeline (Optional)
Set up a GitHub Actions workflow with the following stages:
a. Trigger: On push to the main branch
b. Build and Push: 
   - Build the Docker image
   - Push the image to ECR
c. Deploy: 
   - Update the ECS task definition
   - Trigger an ECS service update

## Project Structure
Organize your repository as follows:
- `/terraform`: Terraform configuration files
- `/app`: The provided Next.js application code (including Dockerfile)
- `/.github/workflows`: GitHub Actions workflow files
- `README.md`: Project documentation

## Important Notes
- Ensure your Terraform code is modular and follows best practices
- Follow the principle of least privilege for all IAM roles and policies
- Be prepared to explain each component of your solution and how they work together
- Follow the principle of least privilege for all IAM roles and policies
- Provide clear comments in your code and comprehensive documentation in your README.md

## Submission Instructions
- Create a new GitHub repository for this project
- Ensure all your code is committed to your GitHub repository
- Provide clear instructions in your README.md on how to deploy your solution
- Email the following to interview@cctechconsulting.com with the subject "DevOps ECS Challenge Submission - [Your Name]":
- Link to your GitHub repository
- A brief explanation of your approach and any challenges you faced

## Evaluation Criteria
Your submission will be evaluated based on:
1. Correct implementation of the required infrastructure and services
2. Effective use of Terraform for infrastructure as code
3. Proper implementation of containerization and ECS deployment
4. Successful integration of the application with RDS
5. Security considerations and implementation
6. Code quality, organization, and documentation
7. Ability to explain your design decisions and approach during the demo

## Demo Expectations
During the follow-up call, be prepared to:
- Show that each requirement was met and explain how
- Demonstrate the end-to-end process and prove it's working
- Answer questions about your solution and the components involved


Good luck! We look forward to seeing your solution.
