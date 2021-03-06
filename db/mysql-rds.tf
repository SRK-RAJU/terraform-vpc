#locals {
#  rds_user = jsondecode(data.aws_secretsmanager_secret_version.secrets-version.secret_string)["RDS_USER"]
# rds_pass = jsondecode(data.aws_secretsmanager_secret_version.secrets-version.secret_string)["RDS_PASS"]
#
# # rds_user="admin"
##  rds_pass="admin123"
#}
##output "all_vpc" {
# # value = local.ALL_CIDR
##}
#
#
#
#resource "aws_db_instance" "mysql" {
#  allocated_storage      = 10
#  #identifier             = "mysqldb-${var.ENV}"
#  identifier             = "mysql-${var.ENV}"
#  engine                 = "mysql"
#  engine_version         = "5.7"
#  instance_class         = "db.t3.micro"
#  db_name                 = "SRKRDS"
#  username               = local.rds_user
#  password               = local.rds_pass
#  #username               = "admin"
#  #password               = "admin123"
#  parameter_group_name   = aws_db_parameter_group.pg.name
#  skip_final_snapshot    = true
#  vpc_security_group_ids = [aws_security_group.mysql.id]
#  db_subnet_group_name   = aws_db_subnet_group.subnet-group.name
#}
#
##resource "aws_db_security_group" "mysql" {
##  name = "mysql-${var.ENV}"
##
##  dynamic "ingress" {
##    for_each = local.ALL_CIDR
##    content {
##      cidr = ingress.value
##    }
##  }
##}
#
#resource "aws_security_group" "mysql" {
#  name        = "mysql-${var.ENV}"
#  description = "mysql-${var.ENV}"
#  # vpc_id      = data.terraform_remote_state.vpc.outputs.DEFAULT_VPC_ID
#  vpc_id      = data.terraform_remote_state.vpc.outputs.VPC_ID
#  ingress = [ {
#    description = "APP"
#    from_port   = 3306
#    to_port     = 3306
#    protocol    = "tcp"
#   cidr_blocks=local.ALL_CIDR
#  # cidr_blocks = concat([data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNET_CIDR], tolist([data.terraform_remote_state.vpc.outputs.DEFAULT_VPC_CIDR]))
#    ipv6_cidr_blocks = []
#    prefix_list_ids  = []
#    security_groups  = []
#    self             = false
#
#
#  }
#    ]
#
#  #egress = [ {
#   # from_port        = 0
#   # to_port          = 0
#   # protocol         = "-1"
#   # cidr_blocks      = ["0.0.0.0/0"]
#   # ipv6_cidr_blocks = ["::/0"]
#  #}
#    egress = [
#      {
#        description      = "egress"
#        from_port        = 0
#        to_port          = 0
#        protocol         = "-1"
#        cidr_blocks      = ["0.0.0.0/0"]
#        ipv6_cidr_blocks = ["::/0"]
#        prefix_list_ids  = []
#        security_groups  = []
#        self             = false
#      }
#    ]
#
#
#    tags = {
#      Name = "mysql-${var.ENV}"
#    }
#}
#
#
#resource "aws_db_parameter_group" "pg" {
#  name   = "mysql-${var.ENV}-pg"
#  family = "mysql5.7"
#}
#
#
##data "aws_subnet" "subnet1" {
# # id = "subnet-0ad57dc9ebbaf5a77"
##}
#
##data "aws_subnet" "subnet2" {
# # id = "subnet-0cf2e0411710c64c7"
##}
#
#resource "aws_db_subnet_group" "subnet-group" {
#  name       = "mysqldb-subnet-group-${var.ENV}"
#  description = "Private subnets for RDS instance"
# # subnet_ids  = [data.aws_subnet.subnet1.id, data.aws_subnet.subnet2.id]
#  subnet_ids = data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNETS
#  #subnet_ids = data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNETS_IDS
#
#  tags = {
#    Name = "mysqldb-subnet-group-${var.ENV}"
#  }
#}
#
#resource "aws_route53_record" "mysql" {
#  #zone_id = data.terraform_remote_state.vpc.outputs.PRIVATE_HOSTED_ID
#  zone_id = data.terraform_remote_state.vpc.outputs.PRIVATE_HOSTED_ZONE_ID
##  zone_id = "Z0154279NRNJNHPQSM7G"
#  #name    = "mysql-${var.ENV}"
#  name    = "mysql-${var.ENV}.roboshop.internal"
#  type    = "CNAME"
#  ttl     = "300"
#  records = [aws_db_instance.mysql.address]
#}
#
#resource "null_resource" "schema-apply" {
# # //depends_on = [aws_route53_record.mysql]
# provisioner "local-exec" {
#    command = <<EOF
#sudo yum install mariadb -y
#curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip"
#cd /tmp
#unzip -o /tmp/mysql.zip
#cd mysql-main
#mysql -h${aws_db_instance.mysql.address} -u${local.rds_user} -p${local.rds_pass} <shipping.sql
#EOF
#  }
#}

# devops batch 63 code


resource "aws_db_instance" "mysql" {

  identifier             = "roboshop-mysql-${var.ENV}"
  allocated_storage      = var.RDS_MYSQL_STORAGE
  engine                 = "mysql"
  engine_version         = var.RDS_ENGINE_VERSION
  instance_class         = var.RDS_INSTANCE_TYPE
  db_name                 = "SRKRDS"
  username               = jsondecode(data.aws_secretsmanager_secret_version.secrets-version.secret_string)["RDS_USER"]
  password               = jsondecode(data.aws_secretsmanager_secret_version.secrets-version.secret_string)["RDS_PASS"]
  parameter_group_name   = aws_db_parameter_group.mysql.name
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.mysql.name
  vpc_security_group_ids = [aws_security_group.allow_mysql.id]
}

resource "aws_security_group" "allow_mysql" {
  name        = "roboshop-mysql-${var.ENV}"
  description = "roboshop-mysql-${var.ENV}"
  vpc_id      = data.terraform_remote_state.vpc.outputs.VPC_ID

  ingress {
    description = "TLS from VPC"
    from_port   = var.RDS_MYSQL_PORT
    to_port     = var.RDS_MYSQL_PORT
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.vpc.outputs.VPC_CIDR, var.WORKSTATION_IP]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "roboshop-redis-${var.ENV}"
  }
}




resource "aws_db_parameter_group" "mysql" {
  name   = "roboshop-${var.ENV}"
  family = "mysql${var.RDS_ENGINE_VERSION}"
}

resource "aws_db_subnet_group" "mysql" {
  name       = "roboshop-mysql-${var.ENV}"
  subnet_ids = data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNETS

  tags = {
    Name = "roboshop-${var.ENV}"
  }
}
resource "aws_route53_record" "mysql" {
  zone_id = data.terraform_remote_state.vpc.outputs.PRIVATE_HOSTED_ZONE_ID
  name    = "mysql-${var.ENV}.${data.terraform_remote_state.vpc.outputs.PRIVATE_HOSTED_ZONE_NAME}"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_db_instance.mysql.address]
}
resource "null_resource" "mysql-schema-apply" {
  provisioner "local-exec" {
    command = <<EOF
cd /tmp
curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip"
unzip -o mysql.zip
cd mysql-main
mysql -h ${aws_db_instance.mysql.address} -u${local.rds_user} -p${local.rds_pass} <shipping.sql
#mysql -h ${aws_db_instance.mysql.address} -u admin -padmin123 <shipping.sql
EOF
  }
}