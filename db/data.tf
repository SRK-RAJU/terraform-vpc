data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "terra-raj"
    key    = "mutable/vpc/${var.ENV}/terraform.tfstate"
    region = "us-east-1"
  }
}

data "aws_secretsmanager_secret" "secrets" {
  name = "secrets/mysqldb/${var.ENV}"
}

data "aws_secretsmanager_secret_version" "secrets-version" {
 secret_id = data.aws_secretsmanager_secret.secrets.id
  #secret_string = "secrets-version-string-to-protect"
}

#data "aws_ami" "ami" {
#  most_recent = true
#  name_regex  = "Centos-7-DevOps-Practice"
#  owners      = ["973714476881"]
#}

data "aws_ami" "ami" {
  most_recent = true
  name_regex  = "Centos-7-DevOps-Practice"
   owners      = ["973714476881"]
 # name_regex  = "base"
  #owners      = ["self"]
}