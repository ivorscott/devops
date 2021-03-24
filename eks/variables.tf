#
# Variables Configuration
#
variable "region" {
  default = "eu-central-1"
  type    = string
}

variable "kubernetes_version" {
  type    = string
  default = "1.18"
}

variable "workers_count" {
  default = 2
}

variable "workers_type" {
  type    = string
  default = "t2.micro"
}

variable "domain_names" {
  description = "The domain names to assign to the load balancer"
}