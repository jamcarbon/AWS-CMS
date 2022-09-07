resource "aws_lb_listener" "cms_alb" {
  load_balancer_arn = aws_lb.cms_nlb.arn
  port              = "80"
  protocol          = "TCP"
  #ssl_policy        = "ELBSecurityPolicy-2015-05"
  #certificate_arn   = "${var.ssl_arn}"
  
  default_action {
    target_group_arn = aws_lb_target_group.alb_tg1.arn
    type             = "forward"
  }
}

resource "aws_alb" "cms_alb" {
  name                             = "${var.project_name}-alb"
  #enable_cross_zone_load_balancing = true
  security_groups                  = ["${aws_security_group.asg-sec-group.id}"]
  subnets                          = [aws_subnet.public_subnet[0].id, aws_subnet.public_subnet[1].id]
  load_balancer_type               = "application"
  internal                         = true
  ip_address_type                  = "ipv4"
  drop_invalid_header_fields       = false
  enable_waf_fail_open             = false
  desync_mitigation_mode           = "defensive"
  
  tags = {
    Name = "${var.project_name}-alb"
  }
}

resource "aws_lb_target_group" "alb_tg1" {
  name        = "${var.project_name}-cms-tg"
  port        = 80
  target_type = "alb"
  protocol    = "TCP"
  vpc_id      = "${aws_vpc.main.id}"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    #timeout             = 3
    #target              = "TCP:80/"
    interval            = 30
    matcher             = "200-399"
  }
}

resource "aws_lb" "cms_nlb" {
  name                 = "${var.project_name}-nlb"
  internal             = false
  load_balancer_type   = "network"
  #subnets              = [for subnet in aws_subnet.public_subnet : subnet.id]
  #vpc_id               = aws_vpc.main.id
  ip_address_type      = "ipv4"

  subnet_mapping {
    subnet_id     = aws_subnet.public_subnet[0].id
    allocation_id = aws_eip.nat.id
  }

  tags = {
    Name = "${var.project_name}-nlb"
  }
}

resource "aws_lb_target_group_attachment" "lb_tga" {
  target_group_arn = aws_lb_target_group.alb_tg1.arn
  target_id        = aws_alb.cms_alb.arn
  port             = 80
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
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "https"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }  

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
    Name = "allow_tls"
  }
}