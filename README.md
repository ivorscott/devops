# devops training

examples

- [eks-traefik](https://github.com/ivorscott/devops/tree/main/eks-traefik)

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

### references

#### links

- [aws in plain english](https://expeditedsecurity.com/aws-in-plain-english/)
- [aws provider - terraform docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [ec2 - aws_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance)
- [authenticating to aws](https://blog.gruntwork.io/a-comprehensive-guide-to-authenticating-to-aws-on-the-command-line-63656a686799d)
- [aws ec2 instance types](https://aws.amazon.com/ec2/instance-types/)
- [aws autoscaling groups - terraform docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group)
- [aws s3 as terraform remote backend - terraform docs](https://www.terraform.io/docs/language/settings/backends/s3.html)
- [aws containers roadmap](https://github.com/aws/containers-roadmap/projects/1)
- [aws ecs vs. eks](https://skyscrapers.eu/insights/ecs-vs-eks)
- [older aws eks and terraform tutorial](https://learnk8s.io/terraform-eks#you-can-provision-an-eks-cluster-with-terraform-too)
- [recent aws eks and terraform tutorial](https://github.com/hashicorp/terraform-provider-kubernetes/tree/master/_examples/eks)
- [aws load balancer service annotations - repo docs](https://github.com/kubernetes-sigs/aws-load-balancer-controller/blob/c2247a44f4361c7012fd03f1962e56d8e888d073/docs/guide/service/annotations.md)
- [aws eks w/ open id connect service accounts](https://marcincuber.medium.com/amazon-eks-with-oidc-provider-iam-roles-for-kubernetes-services-accounts-59015d15cb0c)
- [bug - aws eks only too many pods error ](https://stackoverflow.com/questions/64965832/aws-eks-only-2-pod-can-be-launched-too-many-pods-error/64972286#64972286)
- [aws eks nodes not recreated when template changes - terraform module](https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/docs/faq.md#why-are-nodes-not-recreated-when-the-launch_configurationlaunch_template-is-recreated)
- [using the cluster auto scaler on aws](https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/cloudprovider/aws/README.md)

## terraform

### terraform variables

two types of variables: _output and input variables_

#### 1. input variables

**def:** _input variables serve as parameters for your terraform code._

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

**def:** _outputs define values that will be highlighted to the user when terraform applies. outputs are an easy way to extract attributes from created resources._

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

- at the top level, you have **environments**
- in each environment you have **components**
- in each component you have **files**

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

#### commands

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

#### links

- [resource behavior - terraform docs](https://www.terraform.io/docs/language/resources/behavior.html)
- [lifecycle meta arguments - terraform docs](https://www.terraform.io/docs/language/meta-arguments/lifecycle.html)
- [terraform automation with github actions](https://purple.telstra.com/blog/using-github-actions-and-terraform-for-iac-automation)
- [testing terraform modules with github actions](https://www.hashicorp.com/blog/continuous-integration-for-terraform-modules-with-github-actions)
- [terrascan static code analyzer](https://docs.accurics.com/projects/accurics-terrascan/en/latest/getting-started/quickstart/)
- [annotations in helm w/ terraform](https://medium.com/@nitinnbisht/annotation-in-helm-with-terraform-3fa04eb30b6e)

## github actions

### references

#### links

- [actions/checkout](https://github.com/actions/checkout)
- [deep dive into pull requests](https://frontside.com/blog/2020-05-26-github-actions-pull_request/)
- [javascript actions](https://betterprogramming.pub/a-deep-dive-into-github-actions-51e234da0c50)
- [docker container actions](https://betterprogramming.pub/delving-into-docker-container-actions-588332af5869)
- [github actions for go project](https://medium.com/swlh/setting-up-github-actions-for-go-project-ea84f4ed3a40)
- [github actions: the bad and ugly](https://colinsalmcorner.com/deployment-with-github-actions/)

## gitops and kubernetes

### references

#### commands

- see resources in all namespaces `kubectl get <kind> --all-namespaces` or `kubectl get <kind> -A`
- see resources in specific namespace `kubectl get <kind> -n <namespace>`
- learn about resource specification: `kubectl explain <kind>.<property>`
- inspect resource `kubectl describe <kind>/name` or `kubectl describe <kind> name`
- debug events: `kubectl -n <namespace> get events --sort-by='{.lastTimestamp}'`

#### links

- [github container registry](https://docs.github.com/en/packages/guides/about-github-container-registry)
- [guide to gitops](https://www.weave.works/technologies/gitops/)
- [gitops: high velocity cicd for kubernetes](https://www.weave.works/blog/gitops-high-velocity-cicd-for-kubernetes)
- [kubernetes cluster autoscaler](https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/FAQ.md)

## monitoring and logging

### references

#### links

- [efk stack on kubernetes](https://www.digitalocean.com/community/tutorials/how-to-set-up-an-elasticsearch-fluentd-and-kibana-efk-logging-stack-on-kubernetes)

## dns

### references

#### links

- [moving a domain from namecheap to aws route53](https://www.youtube.com/watch?v=9jamCc3aNZg)
- [point domain to ec2 using aws route53](https://turreta.com/2019/02/27/aws-point-your-namecheap-domain-to-ec2-instance-via-route53/)
- [point domain to aws load balancer](https://turreta.com/2019/03/18/aws-two-a-records-with-alias-to-refer-to-load-balancer/)
- [external dns with route53 in your eks cluster](https://www.padok.fr/en/blog/external-dns-route53-eks)

## traefik

### references

#### links

- [kubernetes and let's encrypt guide](https://doc.traefik.io/traefik/user-guides/crd-acme/)
- [traefik and helm](https://github.com/traefik/traefik-helm-chart#installing)
- [advanced api routing in eks with traefik](https://revolgy.com/blog/advanced-api-routing-in-eks-with-traefik-aws-loadbalancer-controller-and-external-dns/)

## books

- terraform: up and running - o'reilly - yevgeniy brikman
- gitops and kubernetes - manning - yuen, matyushentsev, ekenstam, suen
- traefik api gateway for microservices - apress - sharma, mathur
- amazon web services in action - manning - michael & andreas wittig
