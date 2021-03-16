# devops training

table of contents
- [aws](#aws)
- [terraform](#terraform)
- [gitops and kubernetes](#gitops-and-kubernetes)
- [monitoring and logging](#monitoring-and-logging)
- [traefik](#traefik)
- [books](#books)

## aws

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
- [aws containers roadmap](https://github.com/aws/containers-roadmap/projects/1)
- [aws ecs vs. eks](https://skyscrapers.eu/insights/ecs-vs-eks)
- [aws eks terraform example](https://github.com/hashicorp/terraform-provider-kubernetes/tree/master/_examples/eks)
- [aws eks and terraform tutorial](https://learnk8s.io/terraform-eks#you-can-provision-an-eks-cluster-with-terraform-too)
- [aws eks, gitops, codefresh and terraform tutorial ](https://codefresh.io/continuous-deployment/applying-gitops-continuous-delivery-cd-infrastructure-using-terraform-codefresh-aws-elastic-kubernetes-service-eks/)
- [aws s3 as terraform remote backend - terraform docs](https://www.terraform.io/docs/language/settings/backends/s3.html)
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

## gitops and kubernetes

### references

- [guide to gitops](https://www.weave.works/technologies/gitops/)
- [gitops: high velocity cicd for kubernetes](https://www.weave.works/blog/gitops-high-velocity-cicd-for-kubernetes)

## monitoring and logging

### references

- [efk stack on kubernetes](https://www.digitalocean.com/community/tutorials/how-to-set-up-an-elasticsearch-fluentd-and-kibana-efk-logging-stack-on-kubernetes)

## traefik

### references

- [kubernetes and let's encrypt guide](https://doc.traefik.io/traefik/user-guides/crd-acme/)

## books

- terraform: up and running - o'reilly - yevgeniy brikman
- gitops and kubernetes - manning - yuen, matyushentsev, ekenstam, suen
- traefik api gateway for microservices - apress - sharma, mathur
- amazon web services in action - manning - michael & andreas wittig