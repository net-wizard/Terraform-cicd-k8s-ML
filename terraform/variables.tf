variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "vpc_cidr" {
  description = "VPC CIDR range"
  type        = string
  default     = "10.0.0.0/16"
}

variable "instance_type" {
  description = "Instance type"
  type        = string
  default     = "t3.micro"
}

variable "cluster_name" {
  description = "Cluster name"
  type        = string
  default     = "retailrec-eks"
}

variable "node_group_size" {
  description = "Number of nodes"
  type        = number
  default     = 2
}

variable "allowed_ssh_cidr" {
  description = "Allowed ssh CIDR"
  type        = string
  default     = "0.0.0.0/0"
}

variable "common_tags" {
  description = "Common tags"
  type        = map(string)
  default = {
    "Project"     = "retailrec"
    "Environment" = "dev"
    "ManagedBy"   = "terraform"
  }
}

