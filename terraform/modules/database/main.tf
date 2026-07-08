# Groupement des sous-réseaux isolés pour la DB
resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-${var.environment}-db-subnet-group"
  subnet_ids = var.database_subnet_ids
  tags       = { Name = "${var.project_name}-${var.environment}-db-subnet-group" }
}

# Pare-feu (Security Group) strict pour RDS
resource "aws_security_group" "db" {
  name        = "${var.project_name}-${var.environment}-db-sg"
  description = "Allow inbound traffic from EKS worker nodes only"
  vpc_id      = var.vpc_id

  ingress {
    description     = "PostgreSQL access from EKS nodes"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.eks_nodes_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.project_name}-${var.environment}-db-sg" }
}

# Instance RDS PostgreSQL 15 sécurisée et chiffrée
resource "aws_db_instance" "main" {
  identifier             = "${var.project_name}-${var.environment}-db"
  engine                 = "postgres"
  engine_version         = "15"
  instance_class         = "db.t4g.micro" # Instance économique (Graviton AWS)
  allocated_storage      = 20
  max_allocated_storage  = 50
  db_name                = "kubesecure_db"
  username               = "postgres"
  password               = "SuperSecurePassword123!" # In prod, inject via Secret Manager
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.db.id]
  skip_final_snapshot    = true # Required to allow fast deletion during cleanup

  # DevSecOps Hardening
  storage_encrypted   = true
  deletion_protection = false # False only because we want to destroy it in 30 minutes!
  publicly_accessible = false
}
