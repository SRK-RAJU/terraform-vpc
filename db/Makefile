help:
	@echo "Usage: make dev | make prod"

dev dev-apply:
	rm -rf .terraform
	terraform init -backend-config=dev-backend.tfvars
	terraform apply -auto-approve -var-file=dev.tfvars

prod prod-apply:
	rm -rf .terraform
	terraform init -backend-config=prod-backend.tfvars
	terraform apply -auto-approve -var-file=prod.tfvars

dev-destroy:
	rm -rf .terraform
	terraform init -backend-config=dev-backend.tfvars
	terraform destroy -auto-approve -var-file=dev.tfvars

prod-destroy:
	rm -rf .terraform
	terraform init -backend-config=prod-backend.tfvars
	terraform destroy -auto-approve -var-file=prod.tfvars

