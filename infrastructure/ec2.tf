
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  owners = ["099720109477"]
}

resource "aws_instance" "app_server" {
  for_each = var.instances

  ami           = data.aws_ami.ubuntu.id
  instance_type = each.value

  vpc_security_group_ids = [module.requester_vpc.default_security_group_id]
  subnet_id              = module.requester_vpc.private_subnets[0]

  metadata_options {
    http_tokens   = "required"
    http_endpoint = "enabled"
  }

  root_block_device {
    encrypted   = true
    volume_type = "gp3"
  }

  tags = {
    Name = each.key
  }
}

resource "aws_instance" "public_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.public_instance_type

  vpc_security_group_ids = [aws_vpc.demo.default_security_group_id]
  subnet_id              = aws_subnet.demo_public.id

  metadata_options {
    http_tokens   = "required"
    http_endpoint = "enabled"
  }

  root_block_device {
    encrypted   = true
    volume_type = "gp3"
  }

  tags = {
    Name      = "public-server"
    Terraform = "true"
  }

  depends_on = [
    aws_subnet.demo_public,
    aws_internet_gateway.demo_igw
  ]
}


resource "aws_instance" "private_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.private_instance_type

  vpc_security_group_ids = [aws_vpc.demo.default_security_group_id]
  subnet_id              = aws_subnet.demo_private.id

  metadata_options {
    http_tokens   = "required"
    http_endpoint = "enabled"
  }

  root_block_device {
    encrypted   = true
    volume_type = "gp3"
  }

  tags = {
    Name      = "private-server"
    Terraform = "true"
  }

  depends_on = [
    aws_subnet.demo_private,
    aws_nat_gateway.demo_nat
  ]
}

resource "aws_instance" "isolated_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.isolated_instance_type

  vpc_security_group_ids = [aws_vpc.demo.default_security_group_id]
  subnet_id              = aws_subnet.isolated.id

  metadata_options {
    http_tokens   = "required"
    http_endpoint = "enabled"
  }

  root_block_device {
    encrypted   = true
    volume_type = "gp3"
  }

  tags = {
    Name      = "isolated-server"
    Terraform = "true"
  }

  depends_on = [
    aws_subnet.isolated
  ]
}