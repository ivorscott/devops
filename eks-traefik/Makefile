include .env

# default arguments
hostname ?= ${ENV_HOSTNAME}
zone ?= ${ENV_ZONE_ID}

apply: 
	terraform init
	terraform apply \
	-var hostname="$(hostname)" \
	-var hosted_zone_id="$(zone)" -auto-approve
.PHONY: apply

deploy:
	./setup_ingress.sh $(terraform output -raw acm_cert_arn) $(hostname)
	KUBECONFIG=./kubeconfig kubectl apply -f .

destroy:
	KUBECONFIG=./kubeconfig kubectl delete -f .
	terraform destroy -var hostname="" -var hosted_zone_id="" -auto-approve
.PHONY: destroy
