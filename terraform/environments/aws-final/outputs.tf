output "eks_cluster_name" {
  value = module.compute.cluster_name
}

output "eks_cluster_endpoint" {
  value = module.compute.cluster_endpoint
}

output "rds_postgresql_endpoint" {
  value = module.database.db_endpoint
}
