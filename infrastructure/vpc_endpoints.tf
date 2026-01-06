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
# resource "aws_vpc_endpoint" "ssm_interface_endpoint" {

# }

# # Interface endpoint for EC2 to connect to EC2 Messages
# resource "aws_vpc_endpoint" "ec2_messages_interface_endpoint" {

# }

# # Interface endpoint for EC2 to connect to SSM Messages
# resource "aws_vpc_endpoint" "ssm_messages_interface_endpoint" {

# }