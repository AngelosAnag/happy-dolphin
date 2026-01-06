resource "aws_db_instance" "default" {
  allocated_storage   = 10
  db_name             = "mydb"
  engine              = "mysql"
  engine_version      = "8.0"
  instance_class      = "db.t3.micro"
  username            = "foo"
  password            = "foobarbaz"
  skip_final_snapshot = true

  # Deploy this in the demo VPC created in vpc.tf in an isolated subnet
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.isolated.name
  multi_az               = false
  publicly_accessible    = false
  tags = {
    Name = "demo-rds-instance"
  }
}

resource "aws_db_subnet_group" "isolated" {
  name       = "demo-rds-subnet-group"
  subnet_ids = [aws_subnet.isolated.id]

  tags = {
    Name = "demo-rds-subnet-group"
  }
}