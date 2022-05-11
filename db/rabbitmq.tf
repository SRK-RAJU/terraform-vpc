resource "aws_mq_broker" "rabbitmq" {
  broker_name = "roboshop-${var.ENV}"

  //  configuration {
  //    id       = aws_mq_configuration.config-main.id
  //    revision = aws_mq_configuration.config-main.latest_revision
  //  }

  engine_type        = "RabbitMQ"
  engine_version     = "3.9.13"
  host_instance_type = "mq.t3.micro"
  security_groups    = [aws_security_group.allow_rabbitmq.id]
  subnet_ids         = [data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNETS[0]]

  user {
    username = "roboshop"
    password = "RoboShop1234"
  }
}



//resource "aws_mq_configuration" "config-main" {
//  description             = "roboshop-${var.ENV}"
//  name                    = "roboshop-${var.ENV}"
//  engine_type             = "RabbitMQ"
//  engine_version          = "3.9.13"
//  data                    = ""
//  authentication_strategy = "simple"
//}
//resource "aws_route53_record" "record" {
//  zone_id = data.terraform_remote_state.vpc.outputs.HOSTEDZONE_PRIVATE_ID
//  name    = "rabbitmq-${var.ENV}.${data.terraform_remote_state.vpc.outputs.HOSTEDZONE_PRIVATE_ZONE}"
//  type    = "CNAME"
//  ttl     = "300"
//  records = [aws_mq_broker.rabbitmq.]


resource "aws_security_group" "allow_rabbitmq" {
  name        = "allow_rabbitmq_${var.ENV}"
  description = "Allow rabbitmq"
  vpc_id      = data.terraform_remote_state.vpc.outputs.VPC_ID

  ingress = [
    {
      description      = "SSH"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = [local.ALL_CIDR]
      ipv6_cidr_blocks = []
      self             = false
      prefix_list_ids  = []
      security_groups  = []
    },
    {
      description      = "rabbitmq"
      from_port        = 5672
      to_port          = 5672
      protocol         = "tcp"
      cidr_blocks      =[data.terraform_remote_state.vpc.outputs.VPC_CIDR]
      ipv6_cidr_blocks = []
      self             = false
      prefix_list_ids  = []
      security_groups  = []
    }
  ]

  egress = [
    {
      description      = "ALL"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      self             = false
      prefix_list_ids  = []
      security_groups  = []
    }
  ]

  tags = {
    Name = "allow_rabbitmq_${var.ENV}"
  }
}
