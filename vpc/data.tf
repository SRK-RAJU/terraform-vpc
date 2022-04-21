data "aws_route53_zone" "internal" {
  zone_id      = "Z034785541G9EV6BV8GL"
  private_zone = true
}

data "aws_route53_zone" "public" {
  zone_id      = "Z0624124M15MXS0PMWB3"
  private_zone = false
}
