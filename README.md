# devops training

table of contents

- [aws](#aws)
- [terraform](#terraform)
- [github actions](#github-actions)
- [gitops](#gitops)
- [kubernetes](#kubernetes)
- [monitoring and logging](#monitoring-and-logging)
- [dns](#dns)
- [traefik](#traefik)
- [case studies](#case-studies)

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
- [ips per nic per instance type](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-eni.html#AvailableIpPerENI)

## terraform

### references

#### commands

- initialize folder + pull code from relevant providers:

  `terraform init`

- see what will happen before making changes:

  `terraform plan`

- preview what will be destroyed

  `terraform plan -destroy`

- apply changes

  `terraform apply`

- destroy infrastructure:

  `terraform destroy`

- print dependency tree:

  `terraform graph`

  - graphviz online [dependency example](https://bit.ly/3tim0IE)

- display outputs after using _terraform apply_:

  `terraform output`

  `terraform output <output_name>`

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

## gitops

### references

#### commands

- apply resource manifests to cluster declaratively

  `kubectl apply -f app.yml`

- update manifest with new image tag:

  `kustomize edit set image sample-app=$USERNAME/sample-app:$GITHUB_SHA`

  ```bash
  export VERSION=$(git rev-parse HEAD | cut -c1-7)
  export NEW_IMAGE="username/sample-app:${VERSION}"

  kubectl patch \
    --local \
    -o yaml \
    -f deployment.yaml \
    -p "spec:
          template:
            spec:
              containers:
              - name: sample-app
                image: ${NEW_IMAGE}" \
    > /tmp/newdeployment.yaml
  mv /tmp/newdeployment.yaml deployment.yaml
  git commit deployment.yaml -m "Update sample-app image to ${NEW_IMAGE}"
  git push
  ```

- outputs the images of all deployments in the Namespace

  `kubectl get deploy -o wide | awk '{$1,$7}' | column -t`

#### links

- [github container registry](https://docs.github.com/en/packages/guides/about-github-container-registry)
- [guide to gitops](https://www.weave.works/technologies/gitops/)
- [gitops: high velocity cicd for kubernetes](https://www.weave.works/blog/gitops-high-velocity-cicd-for-kubernetes)
- [event filtering - github workflows](https://github.blog/changelog/2019-09-30-github-actions-event-filtering-updates/)
- [build matrix - managing complex workflows](https://docs.github.com/en/actions/learn-github-actions/managing-complex-workflows#using-a-build-matrix)
- [argocd workflow w/ kustomize & gh actions](https://faun.pub/how-to-build-a-gitops-workflow-with-argocd-kustomize-and-github-actions-f919e7443295)

- [git flow workflow](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow)

## kubernetes

### references

#### commands

- see full internal representation of an object in YAML format:

  `kubectl get <kind> -o=yaml`

  `kubectl get <kind> --output=yaml`

- see all resources in current namespace

  `kubectl get all`

- see resources in all namespaces:

  `kubectl get <kind> --all-namespaces`

  `kubectl get <kind> -A`

- see resources in specific namespace:

  `kubectl get <kind> -n <namespace>`

- learn about resource specification:

  `kubectl explain <kind>.<property>`

- inspect resource:

  `kubectl describe <kind>/name`

  `kubectl describe <kind> name`

- debug events:

  `kubectl -n <namespace> get events --sort-by='{.lastTimestamp}'`

- get cluster roles and role bindings

  `kubectl get clusteroles`

  `kubectl get clusterolebindings`

- see changes made to yaml file

  `kubectl diff -f app.yml`

- cause all pods in a deployment to restart

  `kubectl restart rollback`

#### links

- [kubectl cheatsheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)

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

## case studies

### references

#### links

- [intuit acquired applatix the startup behind argo](https://www.cncf.io/case-studies/intuit/)
