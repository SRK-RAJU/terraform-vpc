resource "aws_docdb_cluster" "docdb" {
  cluster_identifier = "roboshop-${var.ENV}"
  engine             = "docdb"
  #master_username    = "admin1"
  master_username    = jsondecode(data.aws_secretsmanager_secret_version.secrets-version.secret_string)["SSH_USER"]
  #master_password    = "roboshop1"
  master_password    = jsondecode(data.aws_secretsmanager_secret_version.secrets-version.secret_string)["SSH_PASS"]
  ## This is just for lab purpose
  skip_final_snapshot  = true
  db_subnet_group_name = aws_docdb_subnet_group.docdb.name
}

resource "aws_docdb_subnet_group" "docdb" {
  name       = "roboshop-${var.ENV}"
  subnet_ids = data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNETS

  tags = {
    Name = "roboshop-${var.ENV}"
  }
}

resource "aws_docdb_cluster_instance" "cluster_instances" {
  count              = 1
  identifier         = "roboshop-${var.ENV}"
  cluster_identifier = aws_docdb_cluster.docdb.id
  instance_class     = "db.t3.medium"
}


resource "aws_spot_instance_request" "mongodb" {
  ami                    = data.aws_ami.ami.id
  instance_type          = var.MONGODB_INSTANCE_TYPE
  wait_for_fulfillment   = true
  subnet_id              = data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNETS[0]
  vpc_security_group_ids = [aws_security_group.allow-mongodb.id]
  tags = {
    Name = "spot-instance-${var.ENV}"
  }
}

resource "aws_ec2_tag" "mondodb" {
  resource_id = aws_spot_instance_request.mongodb.spot_instance_id
  key         = "Name"
 # value       = "mongodb-${var.ENV}"
  value       = "mongodb-${var.ENV}"
}

resource "aws_route53_record" "mongodb" {
  zone_id = data.terraform_remote_state.vpc.outputs.PUBLIC_HOSTED_ZONE_ID
  name    = "mongodb-${var.ENV}.${data.terraform_remote_state.vpc.outputs.PUBLIC_HOSTED_ZONE_NAME}"
  type    = "A"
  ttl     = "300"
  records = [aws_spot_instance_request.mongodb.private_ip]
}

resource "aws_security_group" "allow-mongodb" {
  name        = "mongodb-${var.ENV}-sg"
  description = "mongodb-${var.ENV}-sg"
  vpc_id      = data.terraform_remote_state.vpc.outputs.VPC_ID

  ingress = [
    {
      description      = "MONGODB"
      from_port        = 27017
      to_port          = 27017
      protocol         = "tcp"
      cidr_blocks      = local.ALL_CIDR
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "SSH"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = local.ALL_CIDR
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress = [
    {
      description      = "egress"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  tags = {
    Name = "mongodb-${var.ENV}"
  }
}
resource "null_resource" "db-deploy" {
  provisioner "remote-exec" {
    connection {
     # host     = aws_spot_instance_request.mongodb.private_ip
      user     = jsondecode(data.aws_secretsmanager_secret_version.secrets-version.secret_string)["SSH_USER"]
      password = jsondecode(data.aws_secretsmanager_secret_version.secrets-version.secret_string)["SSH_PASS"]

      type     = "ssh"
      port=22
      agent=false
      timeout = "1m"


    }

    inline = [
      "sudo apt-get -qq install python",
      "ansible-pull -i localhost,  -U https://github.com/raghudevopsb61/ansible.git roboshop-pull.yml -e COMPONENT=mongodb  -e ENV=${var.ENV}"
    ]
  }
}

#resource "null_resource" "ansible-apply" {
#$ provisioner "remote-exec" {
# connection {
#  type ="ssh"
#  host     = aws_spot_instance_request.mongodb.private_ip
#  user     = local.ssh_user
#  password = local.ssh_pass
#  #password = jsondecode(data.aws_secretsmanager_secret_version.secrets-version.secret_string)["SSH_PASS"]
# }
# inline = [

# "sudo yum install python3-pip -y",
#  "python -m pip install --upgrade 'pymongo[srv]'",
# "sudo pip3 install pip --upgrade",
# "sudo pip3 install ansible",
#  "sudo pip install certifi",


#  "ansible-pull -U https://github.com/raghudevopsb62/ansible roboshop-pull.yml -e COMPONENT=mongodb -e ENV=${var.ENV}"
#"ansible-pull -U https://github.com/raghudevopsb62/ansible roboshop-pull.yml -e ENV=${var.ENV} -e COMPONENT=mongodb"
# "ansible-pull -U https://DevOps-Batches@dev.azure.com/DevOps-Batches/DevOps60/_git/ansible roboshop-pull.yml -e ENV=${var.ENV} -e COMPONENT=mongodb -e APP_VERSION="
#   ]
# }
#}
