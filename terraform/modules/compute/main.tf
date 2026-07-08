# 1. Security Group for the EKS Nodes (Used for filtering traffic toward RDS)
resource "aws_security_group" "eks_nodes" {
  name        = "${var.project_name}-${var.environment}-node-sg"
  description = "Security group for all nodes in the cluster"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name                                        = "${var.project_name}-${var.environment}-node-sg"
    "kubernetes.io/cluster/${var.project_name}" = "owned"
  }
}

resource "aws_security_group_rule" "nodes_internal" {
  description              = "Allow nodes to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.eks_nodes.id
  source_security_group_id = aws_security_group.eks_nodes.id
  to_port                  = 65535
  type                     = "ingress"
}

# 2. The EKS Cluster (Managed Control Plane)
resource "aws_eks_cluster" "main" {
  name     = "${var.project_name}-${var.environment}-cluster"
  role_arn = var.cluster_role_arn
  version  = "1.30" # Stable and enterprise-ready version

  vpc_config {
    subnet_ids              = var.private_subnet_ids
    endpoint_private_access = true
    endpoint_public_access  = true # Enabled for our 30-min demo convenience
  }
}

# 3. The Node Group (The ephemeral EC2 machines that will run the API)
resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.project_name}-${var.environment}-node-group"
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.private_subnet_ids

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  instance_types = ["t3.medium"] # Balanced and cost-effective for EKS worker nodes
  ami_type       = "AL2_x86_64"  # Amazon Linux 2

  # Attach our custom security group to the nodes via launch template properties implicitly 
  # or rely on EKS default remote access block control
  remote_access {
    ec2_ssh_key = null # DevSecOps Hardening: No SSH backdoor allowed
  }

  tags = {
    Environment = var.environment
  }
}
