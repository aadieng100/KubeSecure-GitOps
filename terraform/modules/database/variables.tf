variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "database_subnet_ids" {
  type = list(string)
}

variable "eks_nodes_security_group_id" {
  description = "Security group of the EKS worker nodes to allow access"
  type        = string
}
