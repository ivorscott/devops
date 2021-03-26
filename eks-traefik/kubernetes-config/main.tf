provider "kubernetes" {
  host                   = var.cluster_endpoint
  cluster_ca_certificate = base64decode(var.cluster_ca_cert)
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
    command     = "aws"
  }
}

resource "kubernetes_config_map" "name" {
  depends_on = [var.cluster_name]
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = join(
      "\n",
      formatlist(local.mapped_role_format, var.k8s_node_role_arn),
    )
  }
}

data "tls_certificate" "cluster" {
  url = var.cluster_oidc_issuer_url
}

# Automate OIDC provider - https://bit.ly/3lSk4nz
# Used to authenticate API calls from pods to create, update delete AWS resources without
# extending the IAM Role of the nodes themselves. The abides by the least privileged principle
resource "aws_iam_openid_connect_provider" "identity_provider" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.cluster.certificates.0.sha1_fingerprint]
  url             = var.cluster_oidc_issuer_url
}

# This allows the kubeconfig file to be refreshed during every Terraform apply.
# Optional: this kubeconfig file is only used for manual CLI access to the cluster.
resource "null_resource" "generate-kubeconfig" {
  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --name ${var.cluster_name} --kubeconfig ${path.root}/kubeconfig"
  }
  triggers = {
    always_run = timestamp()
  }
}

locals {
  ServiceAccountName      = "aws-node"
  ServiceAccountNameSpace = "kube-system"
  OIDC = split("https://",var.cluster_oidc_issuer_url)[1]
}

resource "aws_iam_role" "aws_node" {
  name = "aws_node"

  # Role trust policy - Grants an IAM entity permission to assume the role
  # Allow oidc issuer to assume role - https://bit.ly/39ipmDM - https://amzn.to/3cr28gw
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = aws_iam_openid_connect_provider.identity_provider.arn
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "${local.OIDC}:sub" = "system:serviceaccount:${local.ServiceAccountNameSpace}:${local.ServiceAccountName}"
          }
        }
      }
    ]
  })

  tags = {
    "ServiceAccountName"      = local.ServiceAccountName
    "ServiceAccountNameSpace" = local.ServiceAccountNameSpace
  }

  depends_on = [aws_iam_openid_connect_provider.identity_provider]
}

resource "aws_iam_policy" "policy" {
  name        = "test-policy"
  description = "A test policy"

  # Identity-based policies - https://amzn.to/3cpCUiT
  # Control what actions an identity can perform on which resources
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "route53:ChangeResourceRecordSets"
        ],
        Resource = [
          "arn:aws:route53:::hostedzone/*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "route53:ListHostedZones",
          "route53:ListResourceRecordSets"
        ],
        Resource = [
          "*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "ec2:AssignPrivateIpAddresses",
          "ec2:AttachNetworkInterface",
          "ec2:CreateNetworkInterface",
          "ec2:DeleteNetworkInterface",
          "ec2:DescribeInstances",
          "ec2:DescribeTags",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DetachNetworkInterface",
          "ec2:ModifyNetworkInterfaceAttribute",
          "ec2:UnassignPrivateIpAddresses"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "ec2:CreateTags"
        ],
        Resource = [
          "arn:aws:ec2:*:*:network-interface/*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:UpdateAutoScalingGroup",
          "ec2:AttachVolume",
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:CreateRoute",
          "ec2:CreateSecurityGroup",
          "ec2:CreateTags",
          "ec2:CreateVolume",
          "ec2:DeleteRoute",
          "ec2:DeleteSecurityGroup",
          "ec2:DeleteVolume",
          "ec2:DescribeInstances",
          "ec2:DescribeRouteTables",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSubnets",
          "ec2:DescribeVolumes",
          "ec2:DescribeVolumesModifications",
          "ec2:DescribeVpcs",
          "ec2:DescribeDhcpOptions",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DetachVolume",
          "ec2:ModifyInstanceAttribute",
          "ec2:ModifyVolume",
          "ec2:RevokeSecurityGroupIngress",
          "elasticloadbalancing:AddTags",
          "elasticloadbalancing:ApplySecurityGroupsToLoadBalancer",
          "elasticloadbalancing:AttachLoadBalancerToSubnets",
          "elasticloadbalancing:ConfigureHealthCheck",
          "elasticloadbalancing:CreateListener",
          "elasticloadbalancing:CreateLoadBalancer",
          "elasticloadbalancing:CreateLoadBalancerListeners",
          "elasticloadbalancing:CreateLoadBalancerPolicy",
          "elasticloadbalancing:CreateTargetGroup",
          "elasticloadbalancing:DeleteListener",
          "elasticloadbalancing:DeleteLoadBalancer",
          "elasticloadbalancing:DeleteLoadBalancerListeners",
          "elasticloadbalancing:DeleteTargetGroup",
          "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
          "elasticloadbalancing:DeregisterTargets",
          "elasticloadbalancing:DescribeListeners",
          "elasticloadbalancing:DescribeLoadBalancerAttributes",
          "elasticloadbalancing:DescribeLoadBalancerPolicies",
          "elasticloadbalancing:DescribeLoadBalancers",
          "elasticloadbalancing:DescribeTargetGroupAttributes",
          "elasticloadbalancing:DescribeTargetGroups",
          "elasticloadbalancing:DescribeTargetHealth",
          "elasticloadbalancing:DetachLoadBalancerFromSubnets",
          "elasticloadbalancing:ModifyListener",
          "elasticloadbalancing:ModifyLoadBalancerAttributes",
          "elasticloadbalancing:ModifyTargetGroup",
          "elasticloadbalancing:ModifyTargetGroupAttributes",
          "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
          "elasticloadbalancing:RegisterTargets",
          "elasticloadbalancing:SetLoadBalancerPoliciesForBackendServer",
          "elasticloadbalancing:SetLoadBalancerPoliciesOfListener",
          "kms:DescribeKey"
        ],
        Resource = "*"
      },
      {
        Effect   = "Allow",
        Action   = "iam:CreateServiceLinkedRole",
        Resource = "*",
        Condition = {
          "StringLike" = {
            "iam:AWSServiceName" = "elasticloadbalancing.amazonaws.com"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.aws_node.name
  policy_arn = aws_iam_policy.policy.arn
}

# =========================================================
# Helm config
# =========================================================

provider "helm" {
  kubernetes {
    host                   = var.cluster_endpoint
    cluster_ca_certificate = base64decode(var.cluster_ca_cert)
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
      command     = "aws"
    }
  }
}

resource "helm_release" "aws_lb_controller" {
  depends_on = [var.cluster_name]
  name       = "aws-load-balancer-controller"

  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"

  set {
    name  = "clusterName"
    value = var.cluster_name
  }
  set {
    name  = "serviceAccount.create"
    value = false
  }
}

resource "helm_release" "external_dns" {
  depends_on = [aws_iam_role.aws_node]
  name       = "external-dns"

  repository = "https://charts.bitnami.com/bitnami"
  chart      = "external-dns"

  set {
    name  = "provider"
    value = "aws"
  }
  set {
    name  = "aws.zoneType"
    value = "public"
  }
  set {
    name  = "domainFilters"
    value = "{${join(",", ["devpie.io"])}}"

  }
  set {
    name  = "policy"
    value = "sync"
  }
  set {
    name  = "registry"
    value = "txt"
  }
  set {
    name  = "txtOwnerId"
    value = "Z071124325ZQB395B4HUV"
  }
  set {
    name  = "interval"
    value = "3m"
  }
  set {
    name  = "serviceAccount.create"
    value = true
  }
  set {
    name  = "serviceAccount.name"
    value = "aws-node"
  }
  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.aws_node.arn
    type  = "string"
  }
}

