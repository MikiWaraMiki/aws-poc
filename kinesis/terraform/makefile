.PHONY: init plan apply destroy check
ARG = ""

init:
	terraform init -backend-config="./kinesis.tfbackend" -backend-config="${ARG}"
plan:
	make check
	terraform plan -var-file="./config.tfvars"
apply:
	make check
	terraform apply -var-file="./config.tfvars"
destroy:
	make check
	terraform destroy -var-file="./config.tfvars"
check:
	terraform fmt -recursive
	terraform fmt -check
	terraform validate -var-file="./config.tfvars"
