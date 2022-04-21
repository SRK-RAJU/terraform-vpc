data "aws_route53_zone" "internal" {
  zone_id      = "Z01368741LHGOO0T1BT54"
  private_zone = true
}

data "aws_route53_zone" "public" {
  zone_id      = "Z077856535D0FCPZ3R8B"
  private_zone = false
}
