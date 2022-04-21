output "VPC_ID" {
  value = aws_vpc.main.id
}

output "VPC_CIDR" {
  value = aws_vpc.main.cidr_block
}

output "PUBLIC_SUBNETS_IDS" {
  value = aws_subnet.public-subnets.*.id
}

output "PUBLIC_SUBNETS_CIDR" {
  value = aws_subnet.public-subnets.*.cidr_block
}

output "PRIVATE_SUBNETS_IDS" {
  value = aws_subnet.private-subnets.*.id
}

output "PRIVATE_SUBNETS_CIDR" {
  value = aws_subnet.private-subnets.*.cidr_block
}

output "DEFAULT_VPC_ID" {
  value = var.DEFAULT_VPC_ID
}

output "DEFAULT_VPC_CIDR" {
  value = var.DEFAULT_VPC_CIDR
}

output "INTERNAL_HOSTED_ZONEID" {
  value = data.aws_route53_zone.internal.zone_id
}

output "INTERNAL_HOSTED_ZONE_NAME" {
  value = data.aws_route53_zone.internal.name
}

output "PUBLIC_HOSTED_ZONEID" {
  value = data.aws_route53_zone.public.zone_id
}

output "PUBLIC_HOSTED_ZONE_NAME" {
  value = data.aws_route53_zone.public.name
}

output "PUBLIC_ACM_ARN" {
  value = "arn:aws:acm:us-east-1:739561048503:certificate/b1e2e0f8-9c8e-413a-9e9c-a270df2ef9c7"
}

