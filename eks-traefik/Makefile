include .env

# default arguments
hostname ?= ${ENV_HOSTNAME}
zone ?= ${ENV_ZONE_ID}

apply: 
	terraform init
	terraform apply \
	-var hostname="$(hostname)" \
	-var hosted_zone_id="$(zone)" -auto-approve
	./setup_ingress.sh $(hostname)
	KUBECONFIG=./kubeconfig kubectl apply -f .
.PHONY: apply

destroy:
	KUBECONFIG=./kubeconfig kubectl delete -f .
	terraform destroy -var hostname="" hosted_zone_id="" -auto-approve
.PHONY: destroy
