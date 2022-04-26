resource "aws_route_table" "public-table" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "public-rt"
    ENV  = var.ENV
  }
}

resource "aws_route_table" "private-table" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "private-rt"
    ENV  = var.ENV
  }
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public-subnets)
  subnet_id      = aws_subnet.public-subnets.*.id[count.index]
  route_table_id = aws_route_table.public-table.id
}

resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private-subnets)
  subnet_id      = aws_subnet.private-subnets.*.id[count.index]
  route_table_id = aws_route_table.private-table.id
}

resource "aws_route" "public-igw-route" {
  route_table_id         = aws_route_table.public-table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

resource "aws_route" "private-ngw-route" {
  route_table_id         = aws_route_table.private-table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.ngw.id
}

resource "aws_route" "public-peer-route" {
  route_table_id            = aws_route_table.public-table.id
  destination_cidr_block    = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peer-connection.id
}

resource "aws_route" "private-peer-route" {
  route_table_id            = aws_route_table.private-table.id
  destination_cidr_block    = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peer-connection.id
}

resource "aws_route" "default-rtable-route" {
  route_table_id            = data.aws_vpc.default.main_route_table_id
  destination_cidr_block    = var.VPC_CIDR
  vpc_peering_connection_id = aws_vpc_peering_connection.peer-connection.id
}