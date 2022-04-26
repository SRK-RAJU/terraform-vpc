resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.ENV}-igw"
    ENV=var.ENV
  }
}

resource "aws_eip" "nat-gw" {
  vpc = true
  tags = {
    Name = "${var.ENV}-nat-gw-ip"
    ENV  = var.ENV
  }
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.nat-gw.id
  subnet_id     = aws_subnet.public-subnets.*.id[0]
  tags = {
    Name = "${var.ENV}-ngw"
    ENV  = var.ENV
  }
 # tags = {
   # Name = "NAT-gw"
  #}

  depends_on = [aws_internet_gateway.gw]
}
