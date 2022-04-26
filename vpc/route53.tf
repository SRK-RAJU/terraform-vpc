resource "aws_route53_zone_association" "private-dns" {
 # zone_id = data.aws_route53_zone.internal.zone_id
  vpc_id  = aws_vpc.main.id
  zone_id = var.PRIVATE_HOSTED_ZONE_ID
}

