help:
	@echo "Usage: make dev | make prod"

dev dev-apply:
	rm -rf .terraform
	terraform init -backend-config=env-dev/backend.tfvars
	terraform apply -auto-approve -var-file=env-dev/dev.tfvars

prod prod-apply:
	rm -rf .terraform
	terraform init -backend-config=env-prod/backend.tfvars
	terraform apply -auto-approve -var-file=env-prod/prod.tfvars

dev-destroy:
	rm -rf .terraform
	terraform init -backend-config=env-dev/backend.tfvars
	terraform destroy -auto-approve -var-file=env-dev/dev.tfvars -target=aws_nat_gateway.ngw -target=aws_eip.nat-gw

prod-destroy:
	rm -rf .terraform
	terraform init -backend-config=env-prod/backend.tfvars
	terraform destroy -auto-approve -var-file=env-prod/prod.tfvars -target=aws_nat_gateway.ngw -target=aws_eip.nat-gw


