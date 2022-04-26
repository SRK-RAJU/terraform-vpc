output "VPC_ID" {
  value = aws_vpc.main.id
}

output "VPC_CIDR" {
#  value = aws_vpc.main.cidr_block
  value=var.VPC_CIDR
}

output "PUBLIC_SUBNETS" {
  value = aws_subnet.public-subnets.*.id
}

output "PUBLIC_SUBNETS_CIDR" {
  #value = aws_subnet.public-subnets.*.cidr_block
  value = var.PUBLIC_SUBNET_CIDR
}

output "PRIVATE_SUBNETS" {
  value = aws_subnet.private-subnets.*.id
}

output "PRIVATE_SUBNETS_CIDR" {
#  value = aws_subnet.private-subnets.*.cidr_block
  value = var.PRIVATE_SUBNET_CIDR
}

output "DEFAULT_VPC_ID" {
  #value = var.DEFAULT_VPC_ID
  value = data.aws_vpc.default.id
}

output "DEFAULT_VPC_CIDR" {
  #value = var.DEFAULT_VPC_CIDR
  value = data.aws_vpc.default.cidr_block
}

output "PRIVATE_HOSTED_ZONE_ID" {
 # value = data.aws_route53_zone.internal.zone_id
  value = var.PRIVATE_HOSTED_ZONE_ID
}

#output "PRIVATE_HOSTED_ZONE_ID" {
  #value = data.aws_route53_zone.internal.name
#}

output "PUBLIC_HOSTED_ZONE_ID" {
  #value = data.aws_route53_zone.public.zone_id
  value=var.PUBLIC_HOSTED_ZONE_ID
}

#output "PUBLIC_HOSTED_ZONE_NAME" {
  #value = data.aws_route53_zone.PUBLIC_HOSTED_ZONE_NAME.name
#}

output "PUBLIC_ACM_ARN" {
  value = "arn:aws:acm:us-east-1:739561048503:certificate/b1e2e0f8-9c8e-413a-9e9c-a270df2ef9c7"
}
