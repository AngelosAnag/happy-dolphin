resource "aws_vpc_peering_connection" "requester_to_accepter" {
  vpc_id      = module.requester_vpc.vpc_id
  peer_vpc_id = module.accepter_vpc.vpc_id
  auto_accept = true

  tags = {
    Name = "VPC Peering between requester and accepter"
  }

  depends_on = [
    module.requester_vpc,
    module.accepter_vpc
  ]
}

# Route from requester VPC to accepter VPC
resource "aws_route" "requester_to_accepter" {
  count                     = length(module.requester_vpc.private_route_table_ids)
  route_table_id            = module.requester_vpc.private_route_table_ids[count.index]
  destination_cidr_block    = module.accepter_vpc.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.requester_to_accepter.id

  depends_on = [
    aws_vpc_peering_connection.requester_to_accepter
  ]
}

# Route from accepter VPC to requester VPC
resource "aws_route" "accepter_to_requester" {
  count                     = length(module.accepter_vpc.private_route_table_ids)
  route_table_id            = module.accepter_vpc.private_route_table_ids[count.index]
  destination_cidr_block    = module.requester_vpc.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.requester_to_accepter.id

  depends_on = [
    aws_vpc_peering_connection.requester_to_accepter
  ]
}