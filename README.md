# devops training

table of contents
- [aws](#aws)
- [terraform](#terraform)
- [github actions](#github-actions)
- [gitops and kubernetes](#gitops-and-kubernetes)
- [monitoring and logging](#monitoring-and-logging)
- [dns](#dns)
- [traefik](#traefik)
- [books](#books)

## aws

notes: 

- aws automatically provisions for you a classic load balancer when you create a load balancer service
- 

### references
- [aws in plain english](https://expeditedsecurity.com/aws-in-plain-english/)
- [aws provider - terraform docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
  - [ec2 - aws_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance)
- [authenticating to aws](https://blog.gruntwork.io/a-comprehensive-guide-to-authenticating-to-aws-on-the-command-line-63656a686799d)
-  install aws cli
    - homebrew: `brew install awscli`
    - [mac, linux, windows, and docker](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
- [aws ec2 instance types](https://aws.amazon.com/ec2/instance-types/)
- [aws autoscaling groups -  terraform docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group)
- [aws s3 as terraform remote backend - terraform docs](https://www.terraform.io/docs/language/settings/backends/s3.html)
- [aws containers roadmap](https://github.com/aws/containers-roadmap/projects/1)
- [aws ecs vs. eks](https://skyscrapers.eu/insights/ecs-vs-eks)
- [older aws eks and terraform tutorial](https://learnk8s.io/terraform-eks#you-can-provision-an-eks-cluster-with-terraform-too)
- [recent aws eks and terraform tutorial](https://github.com/hashicorp/terraform-provider-kubernetes/tree/master/_examples/eks)
- [aws load balancer nlb-ip mode - repo docs](https://github.com/kubernetes-sigs/aws-load-balancer-controller/blob/c2247a44f4361c7012fd03f1962e56d8e888d073/docs/guide/service/nlb_ip_mode.md)
- [aws load balancer service annotations - repo docs](https://github.com/kubernetes-sigs/aws-load-balancer-controller/blob/c2247a44f4361c7012fd03f1962e56d8e888d073/docs/guide/service/annotations.md)
- [aws eks, aws load balancer controller nlp-ip tutorial](https://aws.amazon.com/blogs/containers/setting-up-end-to-end-tls-encryption-on-amazon-eks-with-the-new-aws-load-balancer-controller/)

## terraform

### terraform variables

two types of variables: _output and input variables_

#### 1. input variables

- __def:__ _input variables serve as parameters for your terraform code._

[input variables - terraform docs](https://www.terraform.io/docs/configuration-0-11/variables.html)

<details>
<summary>example</summary>
<br>

```terraform

variable "number_example" {
  description = "An example of a number variable in Terraform"
  type        = number
  default     = 42
}

variable "list_example" {
  description = "An example of a list in Terraform"
  type        = list
  default     = ["a", "b", "c"]
}

variable "list_numeric_example" {
  description = "An example of a numeric list in Terraform"
  type        = list(number)
  default     = [1, 2, 3]
}

variable "map_example" {
  description = "An example of a map in Terraform"
  type        = map(string)

  default = {
    key1 = "value1"
    key2 = "value2"
    key3 = "value3"
  }
}

variable "object_example" {
  description = "An example of a structural type in Terraform"
  type        = object({
    name    = string
    age     = number
    tags    = list(string)
    enabled = bool
  })

  default = {
    name    = "value1"
    age     = 42
    tags    = ["a", "b", "c"]
    enabled = true
  }
}
```
</details>

#### 2. output variables (aka output values)

- __def:__ _outputs define values that will be highlighted to the user when terraform applies. outputs are an easy way to extract attributes from created resources._

[output values - terraform docs](https://www.terraform.io/docs/configuration-0-11/outputs.html)

<details>
<summary>example</summary>
<br>

```terraform
output "address" {
  value = "${aws_instance.db.public_dns}"
}
```
</details>

### terraform file layout

achieve full isolation between environments

#### 1. put files for each environment into a separate folder
#### 2. set up a different terraform backend for each environment, with a different aws account


<details>
<summary>example</summary>
<br>
layout 

- at the top level, you have __environments__
- in each environment you have __components__
- in each component you have __files__

```
.
├── dev
│   ├── vpc
│   ├── services
│   │   ├── frontend
│   │   └── backend
│   │       ├── variables.tf
│   │       ├── outputs.tf
│   │       └── main.tf
│   └── storage
│       ├── postgres
│       └── redis
│
├── stage
│   ├── vpc
│   ├── services
│   │   ├── frontend
│   │   └── backend
│   └── storage
│       ├── postgres
│       └── redis
│
├── prod
│   ├── vpc
│   ├── services
│   │   ├── frontend
│   │   └── backend
│   └── storage
│       ├── postgres
│       └── redis
│
└── global
    ├── iam
    └── s3
```
</details>



### references
- [0.14+ terraform bug ](https://github.com/terraform-aws-modules/terraform-aws-eks/issues/1162) - use [0.13.6](https://releases.hashicorp.com/terraform/0.13.6/)
- initialize folder + pull code from relevant providers `terraform init`
- see what will happen before making changes `terraform plan`
  - preview what will be destroyed `terraform plan -destroy`
- apply changes `terraform apply`
- destroy infrastructure `terraform destroy`
- print dependency tree `terraform graph`
    - graphviz online [dependency example](https://bit.ly/3tim0IE)
- print outputs after using _terraform apply_
    - `terraform output`
    - `terraform output <output_name>`
- [resource behavior - terraform docs](https://www.terraform.io/docs/language/resources/behavior.html)
- [lifecycle meta arguments - terraform docs](https://www.terraform.io/docs/language/meta-arguments/lifecycle.html)
- [terraform automation with github actions](https://purple.telstra.com/blog/using-github-actions-and-terraform-for-iac-automation)
- [testing terraform modules with github actions](https://www.hashicorp.com/blog/continuous-integration-for-terraform-modules-with-github-actions)
- [terrascan static code analyzer](https://docs.accurics.com/projects/accurics-terrascan/en/latest/getting-started/quickstart/)

## github actions

### references

- [actions/checkout](https://github.com/actions/checkout)
- [deep dive into pull requests](https://frontside.com/blog/2020-05-26-github-actions-pull_request/)
- [javascript actions](https://betterprogramming.pub/a-deep-dive-into-github-actions-51e234da0c50)
- [docker container actions](https://betterprogramming.pub/delving-into-docker-container-actions-588332af5869)
- [github actions for go project](https://medium.com/swlh/setting-up-github-actions-for-go-project-ea84f4ed3a40)
- [github actions: the bas and ugly](https://colinsalmcorner.com/deployment-with-github-actions/)

## gitops and kubernetes

### references

- [github container registry](https://docs.github.com/en/packages/guides/about-github-container-registry)
- [guide to gitops](https://www.weave.works/technologies/gitops/)
- [gitops: high velocity cicd for kubernetes](https://www.weave.works/blog/gitops-high-velocity-cicd-for-kubernetes)

## monitoring and logging

### references

- [efk stack on kubernetes](https://www.digitalocean.com/community/tutorials/how-to-set-up-an-elasticsearch-fluentd-and-kibana-efk-logging-stack-on-kubernetes)

## dns

### references
- [moving a domain from namecheap to aws route53](https://www.youtube.com/watch?v=9jamCc3aNZg)
- [point domain to ec2 using aws route53](https://turreta.com/2019/02/27/aws-point-your-namecheap-domain-to-ec2-instance-via-route53/)
- [point domain to aws load balancer](https://turreta.com/2019/03/18/aws-two-a-records-with-alias-to-refer-to-load-balancer/)
- [Customizing DNS Service](https://kubernetes.io/docs/tasks/administer-cluster/dns-custom-nameservers/)
- [CoreDNS docs](https://coredns.io/manual/toc/)
- [Debugging DNS Resolution](https://kubernetes.io/docs/tasks/administer-cluster/dns-debugging-resolution/)

## traefik

### references

- [kubernetes and let's encrypt guide](https://doc.traefik.io/traefik/user-guides/crd-acme/)

## books

- terraform: up and running - o'reilly - yevgeniy brikman
- gitops and kubernetes - manning - yuen, matyushentsev, ekenstam, suen
- traefik api gateway for microservices - apress - sharma, mathur
- amazon web services in action - manning - michael & andreas wittig
