variable "aws_region" {
  type    = string
}

variable "k8s_version" {
  description = "Desired Kubernetes master version."
  type = string
}

variable "cluster_name" {
  description = "EKS cluster name"
  type = string
  default = "Default Cluster"
}

variable "cluster_subnet_ids" {
  description = "Subnet ids for control plane to place ENIs."
  type = list(string)
}

variable "node_subnet_ids" {
  description = "IDs of subnets to associate with the EKS Node Group."
  type = list(string)
}

variable "cluster_role_name" {
  description = "IAM role name of EKS cluster."
  type = string
  default = "EKS-cluster-role"
}

variable "node_role_name" {
  description = "IAM role name of EKS node."
  type = string
  default = "EKS-node-role"
}

variable "node_groups" {
  description = "Node groups of EKS cluster"
  type = list(object({
    arch = string
    capacity_type = string
    disk_size = number
    instance_types = list(string)
    desired = number
    max = number
    min = number
  }))
}

variable "service_ipv4_cidr" {
  description = "The CIDR block to assign Kubernetes service IP addresses from."
  type = string
  default = "192.168.0.0/16"
}

variable "eks_addons" {
  description = "List of EKS add-on"
  type = list(object({
      name = string
      version = string
  }))
  default = [
    {
        name = "vpc-cni"
        version = "v1.8.0-eksbuild.1"
    },
  ]
}

variable "tags" {
  type        = map(string)
  description = "tags to apply to for all gitlab related service."
  default     = {}
}