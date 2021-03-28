apply: 
	terraform init
	terraform apply -var hostname="devpie.io" -auto-approve
	KUBECONFIG=./kubeconfig kubectl apply -f deployment.yaml
.PHONY: apply

destroy:
	KUBECONFIG=./kubeconfig kubectl delete -f deployment.yaml
	terraform destroy -var hostname="" -auto-approve
.PHONY: destroy
