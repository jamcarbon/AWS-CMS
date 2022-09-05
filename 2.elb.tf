resource "aws_key_pair" "asg-key-pair" {
  key_name   = "${var.key_name}"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}

resource "aws_security_group" "asg-sec-group" {
  name        = "${var.project_name}-asg-sec-group"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id
  
  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
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
    Name = "allow_tls"
  }
}

resource "aws_elb" "cms_elb" {
  name = "${var.project_name}-elbs"
  security_groups = ["${aws_security_group.asg-sec-group.id}"]

  availability_zones = [
    "${var.region}a",
    "${var.region}b",
    "${var.region}c",
  ]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "${var.project_name}"
  }
}

resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = "${aws_autoscaling_group.cms_asg.id}"
  elb                    = "${aws_elb.bar.id}"
}