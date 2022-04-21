resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.ENV}-route-table-public"
  }
}

resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.ENV}-route-table-private"
  }
}


resource "aws_route" "public-route-to-default-vpc" {
  route_table_id            = aws_route_table.public-route-table.id
  destination_cidr_block    = var.DEFAULT_VPC_CIDR
  vpc_peering_connection_id = aws_vpc_peering_connection.peer-to-default-vpc.id
}

resource "aws_route" "private-route-to-default-vpc" {
  route_table_id            = aws_route_table.private-route-table.id
  destination_cidr_block    = var.DEFAULT_VPC_CIDR
  vpc_peering_connection_id = aws_vpc_peering_connection.peer-to-default-vpc.id
}

resource "aws_route" "route-from-default-vpc" {
  route_table_id            = var.DEFAULT_ROUTE_TABLE_ID
  destination_cidr_block    = var.VPC_CIDR
  vpc_peering_connection_id = aws_vpc_peering_connection.peer-to-default-vpc.id
}

resource "aws_route" "route-for-igw" {
  route_table_id         = aws_route_table.public-route-table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}


resource "aws_route" "route-for-ngw" {
  route_table_id         = aws_route_table.private-route-table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.ngw.id
}
