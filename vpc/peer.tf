resource "aws_vpc_peering_connection" "peer-connection" {
  peer_owner_id = data.aws_caller_identity.current.account_id
  #peer_vpc_id = var.DEFAULT_VPC_ID
  peer_vpc_id   = aws_vpc.main.id
  #vpc_id      = aws_vpc.main.id
  vpc_id        = data.aws_vpc.default.id
  auto_accept = true
  tags = {
    Name = "peer-connection"
  }
}

