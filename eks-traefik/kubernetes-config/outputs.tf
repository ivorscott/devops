output "iam_role_arn_external_dns" {
  value = aws_iam_role.external_dns.arn
}

output "iam_role_arn_aws_load_balancer_controller" {
  value = aws_iam_role.aws_load_balancer_controller.arn
}
