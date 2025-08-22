# Random password for database
resource "random_password" "db_password" {
  length  = 16
  special = true
}

# Database Secret in AWS Secrets Manager
resource "aws_secretsmanager_secret" "db_credentials" {
  name                    = "${var.project_name}-${var.environment}-db-credentials"
  description             = "Database credentials for ${var.project_name} ${var.environment}"
  recovery_window_in_days = 7

  tags = {
    Name = "${var.project_name}-${var.environment}-db-secret"
  }
}

resource "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    username = "postgres"
    password = random_password.db_password.result
    engine   = "postgres"
    host     = aws_db_instance.postgres.endpoint
    port     = 5432
    dbname   = aws_db_instance.postgres.db_name
  })
}

# Database Subnet Group
resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-${var.environment}-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "${var.project_name}-${var.environment}-db-subnet-group"
  }
}

# Database Security Group
resource "aws_security_group" "rds" {
  name_prefix = "${var.project_name}-${var.environment}-rds-"
  vpc_id      = var.vpc_id

  ingress {
    description     = "PostgreSQL from App"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.app_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-rds-sg"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# RDS PostgreSQL Instance
resource "aws_db_instance" "postgres" {
  identifier             = "${var.project_name}-${var.environment}-postgres"
  allocated_storage      = var.db_allocated_storage
  max_allocated_storage  = var.db_allocated_storage * 2
  storage_type           = "gp2"
  storage_encrypted      = true
  engine                 = "postgres"
  engine_version         = "15.4"
  instance_class         = var.db_instance_class
  db_name                = "${replace(var.project_name, "-", "")}${var.environment}"
  username               = "postgres"
  password               = random_password.db_password.result
  parameter_group_name   = "default.postgres15"
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  backup_retention_period = 7
  backup_window          = "03:00-04:00"
  maintenance_window     = "sun:04:00-sun:05:00"

  skip_final_snapshot       = true
  final_snapshot_identifier = "${var.project_name}-${var.environment}-postgres-final-snapshot"

  deletion_protection = false

  tags = {
    Name = "${var.project_name}-${var.environment}-postgres"
  }
}