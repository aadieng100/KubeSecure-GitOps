output "cluster_name" {
  value = aws_eks_cluster.main.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.main.endpoint
}

output "cluster_ca_certificate" {
  value = aws_eks_cluster.main.certificate_authority[0].data
}

# DevSecOps Fix: Export the REAL primary security group used by EKS nodes
output "eks_nodes_security_group_id" {
  value = aws_eks_cluster.main.vpc_config[0].cluster_security_group_id
}
