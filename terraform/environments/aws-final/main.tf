# 1. Orchestrate the Network (VPC, Subnets, NAT)
module "network" {
  source       = "../../modules/network"
  project_name = var.project_name
  environment  = var.environment
}

# 2. Orchestrate Identity and Access Management
module "iam" {
  source       = "../../modules/iam"
  project_name = var.project_name
  environment  = var.environment
}

# 3. Orchestrate the EKS Cluster and Worker Nodes
module "compute" {
  source             = "../../modules/compute"
  project_name       = var.project_name
  environment        = var.environment
  vpc_id             = module.network.vpc_id
  private_subnet_ids = module.network.private_subnet_ids
  cluster_role_arn   = module.iam.cluster_role_arn
  node_role_arn      = module.iam.node_role_arn
}

# 4. Orchestrate the Secured RDS PostgreSQL Instance
module "database" {
  source                      = "../../modules/database"
  project_name                = var.project_name
  environment                 = var.environment
  vpc_id                      = module.network.vpc_id
  database_subnet_ids         = module.network.database_subnet_ids
  eks_nodes_security_group_id = module.compute.eks_nodes_security_group_id
}
