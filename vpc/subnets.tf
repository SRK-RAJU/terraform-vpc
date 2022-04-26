resource "aws_subnet" "public-subnets" {
 # count             = var.PUBLIC_SUBNETS
  count             = length(var.PUBLIC_SUBNET_CIDR)
  vpc_id            = aws_vpc.main.id
 # cidr_block        = cidrsubnet(var.VPC_CIDR, 3, count.index)
  cidr_block        = var.PUBLIC_SUBNET_CIDR[count.index]
  #availability_zone = element(var.AZ, count.index)
  availability_zone = var.AZ[count.index]
  tags = {
    Name = "${var.ENV}-public-subnet-${count.index + 1}"
    ENV  = var.ENV
  }
  #tags = {
  #  Name = "public-subnet-${count.index + 1}"
  #}
}

resource "aws_subnet" "private-subnets" {
  count             = length(var.PRIVATE_SUBNET_CIDR)
  #count             = var.PRIVATE_SUBNETS
  #count             = length(var.PRIVATE_SUBNET_CIDR)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.PRIVATE_SUBNET_CIDR[count.index]
  availability_zone = var.AZ[count.index]
#  cidr_block        = cidrsubnet(var.VPC_CIDR, 3, count.index + 2)
 # availability_zone = element(var.AZ, count.index)

 # tags = {
   # Name = "private-subnet-${count.index + 1}"
 # }

  tags = {
    Name = "${var.ENV}-private-subnet-${count.index + 1}"
    ENV  = var.ENV
  }
}

#resource "aws_route_table_association" "rt-assoc-public" {
  #count          = var.PUBLIC_SUBNETS
  #subnet_id      = element(aws_subnet.public-subnets.*.id, count.index)
  #route_table_id = aws_route_table.public-route-table.id
#}

#resource "aws_route_table_association" "rt-assoc-priv" {
#  count          = var.PRIVATE_SUBNETS
 # subnet_id      = element(aws_subnet.private-subnets.*.id, count.index)
 # route_table_id = aws_route_table.private-route-table.id
#}

