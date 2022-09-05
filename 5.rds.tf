resource "aws_db_subnet_group" "cms" {
  name       = "${var.project_name}-rds-subnet"
  subnet_ids = [aws_subnet.private-us-east-1a.id, aws_subnet.private-us-east-1b.id, aws_subnet.public-us-east-1a.id, aws_subnet.public-us-east-1b.id]
  tags = {"Name" : "${var.project_name}"}
}

resource "aws_security_group" "rds-sec-group" {
  name        = "${var.project_name}-asg-sec-group"
  description = "Accept traffic from instance security group"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "RDS ingress"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  tags = {
    Name = "allow_rds"
  }
}