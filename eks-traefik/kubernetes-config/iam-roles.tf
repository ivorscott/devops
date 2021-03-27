resource "aws_iam_role" "external_dns" {
  name     = "external_dns"

  assume_role_policy = templatefile("${path.module}/policies/oidc-assume-role-policy.json", {
    OIDC_ARN=aws_iam_openid_connect_provider.cluster.arn,
    OIDC_URL=split("https://", var.cluster_oidc_issuer_url)[1],
    NAMESPACE="kube-system",
    SA_NAME="external_dns"
  })

  tags = {
    "ServiceAccountName"      = "external_dns"
    "ServiceAccountNameSpace" = "kube-system"
  }
}

resource "aws_iam_role_policy" "external_dns" {
  name = "CustomPolicy"
  role = aws_iam_role.external_dns.id
  policy = templatefile("${path.module}/policies/external-dns-policy.json", {})
}

resource "aws_iam_role" "aws_load_balancer_controller" {
  name     = "aws_load_balancer_controller"

  assume_role_policy = templatefile("${path.module}/policies/oidc-assume-role-policy.json", {
    OIDC_ARN=aws_iam_openid_connect_provider.cluster.arn,
    OIDC_URL=split("https://", var.cluster_oidc_issuer_url)[1],
    NAMESPACE="kube-system",
    SA_NAME="aws_load_balancer_controller"
  })

  tags = {
    "ServiceAccountName"      = "aws_load_balancer_controller"
    "ServiceAccountNameSpace" = "kube-system"
  }
}

resource "aws_iam_role_policy" "aws_load_balancer_controller" {
  name = "CustomPolicy"
  role = aws_iam_role.aws_load_balancer_controller.id
  policy = templatefile("${path.module}/policies/aws-load-balancer-controller-policy.json", {})
}