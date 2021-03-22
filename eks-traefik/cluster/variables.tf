variable "cluster_name" {
  description = "The name of the eks cluster"
  default = "my-cluster"
}

variable "cluster_region" {
  description = "The region of the eks cluster"
}

variable "instance_type" {
  description = "The instance type for eks cluster nodes"
  default = "m5.large"
}
