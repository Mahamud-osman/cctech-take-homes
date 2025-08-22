data "aws_caller_identity" "current" {}

# Networking Module
module "networking" {
  source = "./modules/networking"

  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
  environment        = var.environment
  project_name       = var.project_name
}

# Compute Module (ECS + ECR)
module "compute" {
  source = "./modules/compute"

  vpc_id              = module.networking.vpc_id
  private_subnet_ids  = module.networking.private_subnet_ids
  public_subnet_ids   = module.networking.public_subnet_ids
  environment         = var.environment
  project_name        = var.project_name
  application_name    = var.application_name
}

# Database Module
module "database" {
  source = "./modules/database"

  vpc_id                    = module.networking.vpc_id
  private_subnet_ids        = module.networking.private_subnet_ids
  app_security_group_id     = module.compute.app_security_group_id
  environment               = var.environment
  project_name              = var.project_name
  db_instance_class         = var.db_instance_class
  db_allocated_storage      = var.db_allocated_storage
}