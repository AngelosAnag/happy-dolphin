
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