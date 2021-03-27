output "kubeconfig_path" {
  value = abspath("${path.root}/kubeconfig")
}

output "cluster_name" {
  value = module.vpc.cluster_name
}

output "iam_role_arn_external_dns" {
  value = module.kubernetes-config.iam_role_arn_external_dns
}

output "iam_role_arn_aws_load_balancer_controller" {
  value = module.kubernetes-config.iam_role_arn_aws_load_balancer_controller
}
