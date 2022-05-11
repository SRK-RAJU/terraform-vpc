#/*
#resource "aws_mq_broker" "rabbitmq" {
#  broker_name = "roboshop-${var.ENV}"
#
#  //  configuration {
#  //    id       = aws_mq_configuration.config-main.id
#  //    revision = aws_mq_configuration.config-main.latest_revision
#  //  }
#
#  engine_type        = "RabbitMQ"
#  engine_version     = "3.9.13"
#  host_instance_type = "mq.t3.micro"
#  security_groups    = [aws_security_group.allow_rabbitmq.id]
#  subnet_ids         = [data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNETS[0]]
#
#  user {
##    username = "roboshop"
#    password = "RoboShop1234"
#  }
#}
#
#
#//resource "aws_mq_configuration" "config-main" {
#//  description             = "roboshop-${var.ENV}"
#//  name                    = "roboshop-${var.ENV}"
#//  engine_type             = "RabbitMQ"
#//  engine_version          = "3.9.13"
#//  data                    = ""
#//  authentication_strategy = "simple"
#//}
#//resource "aws_route53_record" "record" {
#//  zone_id = data.terraform_remote_state.vpc.outputs.HOSTEDZONE_PRIVATE_ID
#//  name    = "rabbitmq-${var.ENV}.${data.terraform_remote_state.vpc.outputs.HOSTEDZONE_PRIVATE_ZONE}"
#//  type    = "CNAME"
#//  ttl     = "300"
#//  records = [aws_mq_broker.rabbitmq.]
#
#
#resource "aws_security_group" "allow_rabbitmq" {
#  name        = "allow_rabbitmq_${var.ENV}"
#  description = "Allow rabbitmq"
#  vpc_id      = data.terraform_remote_state.vpc.outputs.VPC_ID
#
#  ingress = [
#    {
#      description      = "SSH"
#      from_port        = 22
#      to_port          = 22
#      protocol         = "tcp"
#      cidr_blocks      = [local.ALL_CIDR]
#      ipv6_cidr_blocks = []
#      self             = false
#      prefix_list_ids  = []
#      security_groups  = []
#    },
#    {
#      description      = "rabbitmq"
#      from_port        = 5672
#      to_port          = 5672
#      protocol         = "tcp"
#      cidr_blocks      = [data.terraform_remote_state.vpc.outputs.VPC_CIDR]
#      ipv6_cidr_blocks = []
#      self             = false
#      prefix_list_ids  = []
#      security_groups  = []
#    }
#  ]
#
#  egress = [
#    {
#      description      = "ALL"
#      from_port        = 0
#      to_port          = 0
#      protocol         = "-1"
#      cidr_blocks      = ["0.0.0.0/0"]
#      ipv6_cidr_blocks = []
#      self             = false
#      prefix_list_ids  = []
#      security_groups  = []
#    }
#  ]
#
#  tags = {
#    Name = "allow_rabbitmq_${var.ENV}"
#  }
#}


resource "aws_security_group" "allow_rabbitmq" {
  name        = "rabbitmq-${var.ENV}"
  description = "rabbitmq-${var.ENV}"
  vpc_id      = data.terraform_remote_state.vpc.outputs.VPC_ID

  ingress {
    description = "TLS from VPC"
    from_port   = var.RABBITMQ_PORT
    to_port     = var.RABBITMQ_PORT
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.vpc.outputs.VPC_CIDR]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.vpc.outputs.VPC_CIDR, "172.31.15.197/32"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "rabbitmq-${var.ENV}"
  }
}

//resource "aws_mq_broker" "rabbitmq" {
//  broker_name = "roboshop-${var.ENV}"
//
//  engine_type        = "RabbitMQ"
//  engine_version     = var.RABBITMQ_ENGINE_VERSION
//  host_instance_type = var.RABBITMQ_INSTANCE_TYPE
//  security_groups    = [aws_security_group.allow_rabbitmq.id]
//  subnet_ids         = [data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNET_IDS[0]]
//
//  user {
//    username = jsondecode(data.aws_secretsmanager_secret_version.secrets.secret_string)["RABBITMQ_USERNAME"]
//    password = jsondecode(data.aws_secretsmanager_secret_version.secrets.secret_string)["RABBITMQ_PASSWORD"]
//  }
//}

resource "aws_spot_instance_request" "rabbitmq" {
  ami                    = data.aws_ami.ami.id
  instance_type          = "t3.micro"
  wait_for_fulfillment   = true
  vpc_security_group_ids = [aws_security_group.allow_rabbitmq.id]
  subnet_id              = data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNETS[0]

  tags = {
    Name = "rabbitmq-${var.ENV}"
  }
}

resource "null_resource" "app-deploy" {
  provisioner "remote-exec" {
    connection {
      host     = aws_spot_instance_request.rabbitmq.private_ip
      user     = jsondecode(data.aws_secretsmanager_secret_version.secrets-version.secret_string)["SSH_USER"]
      password = jsondecode(data.aws_secretsmanager_secret_version.secrets-version.secret_string)["SSH_PASS"]
    }
    inline = [
      "ansible-pull -U https://github.com/raghudevopsb63/ansible roboshop.yml  -e role_name=rabbitmq -e HOST=localhost  -e ENV=${var.ENV}"
    ]
  }
}

resource "aws_route53_record" "record" {
  zone_id = data.terraform_remote_state.vpc.outputs.PRIVATE_HOSTED_ZONE_ID
  name    = "rabbitmq-${var.ENV}.${data.terraform_remote_state.vpc.outputs.PRIVATE_HOSTED_ZONE_NAME}"
  type    = "A"
  ttl     = "300"
  records = [aws_spot_instance_request.rabbitmq.private_ip]
}