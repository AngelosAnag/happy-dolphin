# Gateway endpoint for isolated subnets to connect to S3

# resource "aws_vpc_endpoint" "s3_gateway_endpoint" {
#   vpc_id            = aws_vpc.demo.id
#   service_name      = "com.amazonaws.${var.region}.s3"
#   vpc_endpoint_type = "Gateway"

#   route_table_ids = [
#     aws_route_table.demo_private_rt.id,
#     aws_route_table.demo_isolated_rt.id
#   ]

#   tags = {
#     Name = "s3-gateway-endpoint"
#   }
# }

# Interface endpoint for EC2 to connect to SSM
resource "aws_vpc_endpoint" "ssm_interface_endpoint" {
  vpc_id              = aws_vpc.demo.id
  service_name        = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  subnet_ids = [
    aws_subnet.isolated.id,
    aws_subnet.isolated_2.id
  ]

  security_group_ids = [
    aws_security_group.vpc_endpoints.id
  ]

  tags = {
    Name = "ssm-interface-endpoint"
  }
}

# Interface endpoint for EC2 to connect to EC2 Messages
resource "aws_vpc_endpoint" "ec2_messages_interface_endpoint" {
  vpc_id              = aws_vpc.demo.id
  service_name        = "com.amazonaws.${var.region}.ec2messages"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  subnet_ids = [
    aws_subnet.isolated.id,
    aws_subnet.isolated_2.id
  ]

  security_group_ids = [
    aws_security_group.vpc_endpoints.id
  ]

  tags = {
    Name = "ec2messages-interface-endpoint"
  }
}

# Interface endpoint for EC2 to connect to SSM Messages
resource "aws_vpc_endpoint" "ssm_messages_interface_endpoint" {
  vpc_id              = aws_vpc.demo.id
  service_name        = "com.amazonaws.${var.region}.ssmmessages"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  subnet_ids = [
    aws_subnet.isolated.id,
    aws_subnet.isolated_2.id
  ]

  security_group_ids = [
    aws_security_group.vpc_endpoints.id
  ]

  tags = {
    Name = "ssmmessages-interface-endpoint"
  }
}