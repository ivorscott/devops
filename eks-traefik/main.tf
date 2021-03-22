module "dev_cluster" {
  source = "./cluster"
  cluster_name = "dev"
  cluster_region = "eu-central-1"
  instance_type = "t2.micro"
}
