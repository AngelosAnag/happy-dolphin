provider "aws" {
  region = "eu-central-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "app_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  # Fix 1: Enforce IMDSv2
  metadata_options {
    http_tokens   = "required" # Require session tokens
    http_endpoint = "enabled"
  }

  # Fix 2: Encrypt root block device
  root_block_device {
    encrypted   = true
    volume_type = "gp3"
  }

  tags = {
    Name = "tf-test-instance"
  }
}