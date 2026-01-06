module "example_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.19.0"

  name = "example-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["eu-central-1a", "eu-central-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24"]

  enable_dns_hostnames = true
  enable_dns_support   = true
}

module "requester_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.19.0"

  name = "peer-requester-vpc"
  cidr = "10.10.0.0/16"

  azs             = ["eu-central-1a", "eu-central-1b"]
  private_subnets = ["10.10.1.0/24", "10.10.2.0/24"]
  public_subnets  = ["10.10.101.0/24"]

  enable_dns_hostnames   = true
  enable_dns_support     = true
  enable_nat_gateway     = false # Disabled to avoid EIP limit
  single_nat_gateway     = false
  one_nat_gateway_per_az = false
}

module "accepter_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.19.0"

  name = "peer-accepter-vpc"
  cidr = "10.11.0.0/16"

  azs             = ["eu-central-1a", "eu-central-1b"]
  private_subnets = ["10.11.1.0/24", "10.11.2.0/24"]
  public_subnets  = ["10.11.101.0/24"]

  enable_dns_hostnames   = true
  enable_dns_support     = true
  enable_nat_gateway     = false # Disabled to avoid EIP limit
  single_nat_gateway     = false
  one_nat_gateway_per_az = false
}

resource "aws_vpc" "demo" {
  cidr_block = var.main_vpc_cidr
  tags = {
    Name = "demo-vpc"
  }
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "demo_public" {
  vpc_id            = aws_vpc.demo.id
  cidr_block        = var.demo_public_subnet_cidr
  availability_zone = var.demo_public_subnet_az
  tags = {
    Name = "demo-public-subnet"
  }
  map_public_ip_on_launch = true
  depends_on              = [aws_vpc.demo]
}

resource "aws_subnet" "demo_private" {
  vpc_id            = aws_vpc.demo.id
  cidr_block        = var.demo_private_subnet_cidr
  availability_zone = var.demo_private_subnet_az
  tags = {
    Name = "demo-private-subnet"
  }
  map_public_ip_on_launch = false
  depends_on              = [aws_vpc.demo]
}

resource "aws_internet_gateway" "demo_igw" {
  vpc_id = aws_vpc.demo.id
  tags = {
    Name = "demo-igw"
  }
}

resource "aws_route_table" "demo_public_rt" {
  vpc_id = aws_vpc.demo.id
  tags = {
    Name = "demo-public-rt"
  }
}
resource "aws_route" "demo_public_internet_access" {
  route_table_id         = aws_route_table.demo_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.demo_igw.id
}

resource "aws_route_table_association" "demo_public_rta" {
  subnet_id      = aws_subnet.demo_public.id
  route_table_id = aws_route_table.demo_public_rt.id

  depends_on = [
    aws_route_table.demo_public_rt,
    aws_subnet.demo_public
  ]
}

resource "aws_eip" "demo_nat_eip" {
  domain = "vpc"
  tags = {
    Name = "demo-nat-eip"
  }
  depends_on = [aws_internet_gateway.demo_igw]
}

resource "aws_nat_gateway" "demo_nat" {
  allocation_id = aws_eip.demo_nat_eip.id
  subnet_id     = aws_subnet.demo_public.id
  tags = {
    Name = "demo-nat-gateway"
  }
  depends_on = [aws_internet_gateway.demo_igw]
}

resource "aws_route_table" "demo_private_rt" {
  vpc_id = aws_vpc.demo.id
  tags = {
    Name = "demo-private-rt"
  }
}

resource "aws_route" "demo_private_nat_gateway" {
  route_table_id         = aws_route_table.demo_private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.demo_nat.id
}

resource "aws_route_table_association" "demo_private_rta" {
  subnet_id      = aws_subnet.demo_private.id
  route_table_id = aws_route_table.demo_private_rt.id

  depends_on = [
    aws_route_table.demo_private_rt,
    aws_subnet.demo_private
  ]
}

resource "aws_subnet" "isolated" {
  vpc_id            = aws_vpc.demo.id
  cidr_block        = var.demo_isolated_subnet_cidr
  availability_zone = var.demo_isolated_subnet_az
  tags = {
    Name = "demo-isolated-subnet"
  }
  map_public_ip_on_launch = false
  depends_on              = [aws_vpc.demo]
}