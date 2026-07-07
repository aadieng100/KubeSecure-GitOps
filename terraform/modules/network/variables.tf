variable "project_name" {
  description = "Name of the project used for namespacing"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "vpc_cidr" {
  description = "Base CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of target availability zones"
  type        = list(string)
  default     = ["eu-west-3a", "eu-west-3b"] # Paris by default, adapt if needed
}
