output "kubeconfig_path" {
  value = abspath("${path.root}/kubeconfig")
}

output "cluster_name" {
  value = module.vpc.cluster_name
}

output "lb_dns_name" {
  value = module.kubernetes-config.aws_elb_dns_name
}

output "domain_names" {
  value = var.domain_names
}