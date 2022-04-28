resource "aws_spot_instance_request" "spot-instance" {
  ami                    = data.aws_ami.ami.id
  instance_type          = var.MONGODB_INSTANCE_TYPE
  wait_for_fulfillment   = true
  subnet_id              = data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNETS[0]
  vpc_security_group_ids = [aws_security_group.allow-mongodb.id]
  tags = {
    Name = "spot-instance-${var.ENV}"
  }
}

resource "aws_ec2_tag" "tag" {
  resource_id = aws_spot_instance_request.spot-instance.spot_instance_id
  key         = "Name"
 # value       = "mongodb-${var.ENV}"
  value       = "tag-${var.ENV}"
}


resource "null_resource" "ansible-apply" {
  provisioner "remote-exec" {
    connection {
      host     = aws_spot_instance_request.spot-instance.private_ip
      user     = local.ssh_user
      password = local.ssh_pass
      #password = jsondecode(data.aws_secretsmanager_secret_version.secrets-version.secret_string)["SSH_PASS"]
    }
    inline = [
    #  "ansible-pull -U https://github.com/raghudevopsb62/ansible roboshop-pull.yml -e COMPONENT=mongodb -e ENV=${var.ENV}"\
      "ansible-pull -U https://github.com/raghudevopsb62/ansible roboshop-pull.yml -e COMPONENT=mongodb -e ENV=${var.ENV}  -e APP_VERSION="
    ]
  }
}

resource "aws_route53_record" "mongodb" {
  zone_id = data.terraform_remote_state.vpc.outputs.PUBLIC_HOSTED_ZONE_ID
  name    = "mongodb-${var.ENV}.${data.terraform_remote_state.vpc.outputs.PUBLIC_HOSTED_ZONE_NAME}"
  type    = "A"
  ttl     = "300"
  records = [aws_spot_instance_request.spot-instance.private_ip]
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