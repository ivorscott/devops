variable "lb_dns_name" {
  description = "The dns name for the load balancer"
}

variable "lb_zone_id" {
  description = "The zone id for the load balancer"
}

variable "domain_names" {
  description = "The domain names to assign to the load balancer"
  type        = list(string)
}