#data "aws_route53_zone" "internal" {
#  zone_id    = "Z0154279NRNJNHPQSM7G"
  #private_zone = true
#}

#data "aws_route53_zone" "public" {
 # zone_id    = "Z07853641AN6Q7RA4VOKL"
 # private_zone = false
#}

data "aws_caller_identity" "current" {}

data "aws_vpc" "default" {
  default = true
}
