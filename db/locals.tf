locals {
  rds_user = jsondecode(data.aws_secretsmanager_secret_version.secrets-version.secret_string)["RDS_USER"]
  rds_pass = jsondecode(data.aws_secretsmanager_secret_version.secrets-version.secret_string)["RDS_PASS"]
  #DEFAULT_VPC_CIDR = split(",", data.terraform_remote_state.vpc.outputs.DEFAULT_VPC_CIDR)
  #ALL_CIDR         = concat[data.terraform_remote_state.vpc.outputs.VPC_CIDR, local.DEFAULT_VPC_CIDR]
  ALL_CIDR         = [data.terraform_remote_state.vpc.outputs.VPC_CIDR]
}