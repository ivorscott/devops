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

variable "hostname" {
  description = "The application domain name (e.g., example.com)"
  type = string
}
