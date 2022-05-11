locals {
  #rds_user = jsondecode(data.aws_secretsmanager_secret_version.secrets-version.secret_string)["RDS_USER"]
 # rds_pass = jsondecode(data.aws_secretsmanager_secret_version.secrets-version.secret_string)["RDS_PASS"]
 # DEFAULT_VPC_CIDR = split(",", data.terraform_remote_state.vpc.outputs.DEFAULT_VPC_CIDR)
  #ALL_CIDR         = concat[data.terraform_remote_state.vpc.outputs.VPC_CIDR,local.DEFAULT_VPC_CIDR]
 # ALL_CIDR         = [data.terraform_remote_state.vpc.outputs.DEFAULT_VPC_CIDR]

  #ssh_user         = jsondecode(data.aws_secretsmanager_secret_version.secrets-version.secret_string)["SSH_USER"]
  #sh_pass         = jsondecode(data.aws_secretsmanager_secret_version.secrets-version.secret_string)["SSH_PASS"]

  D_VPC_CIDR = split(",", data.terraform_remote_state.vpc.outputs.DEFAULT_VPC_CIDR)
  ALL_CIDR         = concat(data.terraform_remote_state.vpc.outputs.ALL_VPC_CIDR, local.D_VPC_CIDR)

  DNS_NAME = aws_docdb_cluster.docdb.endpoint
  USERNAME = jsondecode(data.aws_secretsmanager_secret_version.secrets-version.secret_string)["SSH_USER"]
  PASSWORD = jsondecode(data.aws_secretsmanager_secret_version.secrets-version.secret_string)["SSH_PASS"]
}
