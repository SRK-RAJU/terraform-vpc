resource "aws_route53_record" "mysql" {
  zone_id = data.terraform_remote_state.vpc.outputs.INTERNAL_HOSTED_ZONEID
  #name    = "mysql-${var.ENV}.${data.terraform_remote_state.vpc.outputs.INTERNAL_HOSTED_ZONE_NAME}"
  name    = "mysql-${var.ENV}.roboshop.internal"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_db_instance.default.address]
}
