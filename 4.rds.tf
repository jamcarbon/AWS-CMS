resource "aws_db_subnet_group" "cms" {
  name       = "${var.project_name}-rds-subnet"
  subnet_ids = [aws_subnet.private_subnet[1].id, aws_subnet.private_subnet[0].id]
  tags = {"Name" : "${var.project_name}"}
}

resource "aws_security_group" "rds-sec-group" {
  name        = "${var.project_name}-rds-sec-group"
  description = "Accept traffic from instance security group"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "RDS ingress"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_rds"
  }
}

resource "aws_db_instance" "DataBase" {
  allocated_storage    = 20
  max_allocated_storage = 100
  storage_type         = "gp2"
  engine               = "mariadb"
  engine_version       = "10.6"
  instance_class       = "db.t2.micro"
  db_name              = "mydb"
  username             = "root"
  password             = "$w#CffEeoXNaG"
  parameter_group_name = "default.mariadb10.6"
  publicly_accessible = false
  db_subnet_group_name = aws_db_subnet_group.cms.name
  vpc_security_group_ids = [aws_security_group.rds-sec-group.id]
  skip_final_snapshot = true 

provisioner "local-exec" {
  command = "echo ${aws_db_instance.DataBase.endpoint} > DB_host.txt"
    }

}
