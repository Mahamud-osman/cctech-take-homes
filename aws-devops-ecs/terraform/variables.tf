# General variables
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name of the project for resource tagging"
  type        = string
  default     = "ecs-nextjs-app"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

# VPC and Networking variables
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# RDS variables
variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "db_name" {
  description = "Name of the database"
  type        = string
  default     = "nextjsapp"
}

variable "db_username" {
  description = "Database master username"
  type        = string
  default     = "postgres"
}

variable "db_allocated_storage" {
  description = "Allocated storage for RDS instance in GB"
  type        = number
  default     = 20
}

variable "db_engine_version" {
  description = "PostgreSQL engine version"
  type        = string
  default     = "14.10"
}

# ECS variables
variable "app_name" {
  description = "Name of the application"
  type        = string
  default     = "nextjs-app"
}

variable "app_port" {
  description = "Port the application runs on"
  type        = number
  default     = 3000
}

variable "app_count" {
  description = "Number of application instances"
  type        = number
  default     = 2
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units"
  type        = number
  default     = 256
}

variable "fargate_memory" {
  description = "Fargate instance memory"
  type        = number
  default     = 512
}

# Load Balancer variables
variable "alb_name" {
  description = "Name of the Application Load Balancer"
  type        = string
  default     = "ecs-alb"
}

variable "health_check_path" {
  description = "Health check path for the ALB"
  type        = string
  default     = "/"
}

# ECR variables
variable "ecr_repository_name" {
  description = "Name of the ECR repository"
  type        = string
  default     = "nextjs-app"
}

variable "ecr_image_tag" {
  description = "Tag for the Docker image"
  type        = string
  default     = "latest"
}

# Security Group variables
variable "alb_ingress_cidr" {
  description = "CIDR block for ALB ingress"
  type        = string
  default     = "0.0.0.0/0"
}

# Tags
variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default = {
    Project     = "ecs-nextjs-app"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
} 