provider "aws" {
  region = "${var.region}"
}

resource "tls_private_key" "my_key" {
  algorithm = "RSA"
}

# Generate a key-pair with above key
resource "aws_key_pair" "asg-key-pair" {
  key_name   = "cms-key"
  public_key = tls_private_key.my_key.public_key_openssh
}

# Saving Key Pair for ssh login for Client if needed
resource "null_resource" "save_key_pair"  {
	provisioner "local-exec" {
	    command = "echo  ${tls_private_key.my_key.private_key_pem} > cms.pem"
  	}
}

data "template_file" "init" {
  template = "${file("${path.module}/scripts/wordpress.sh")}"
}

resource "aws_launch_template" "cms_lt" {
  name_prefix            = "${var.project_name}-lt"
  image_id               = "ami-0aaabe9caaadf6204" #bitnami wordpress
  instance_type          = "t2.micro"
  key_name               = "${aws_key_pair.asg-key-pair.key_name}"
  vpc_security_group_ids = ["${aws_security_group.asg-sec-group.id}"]
  user_data = "${base64encode(data.template_file.init.rendered)}"
}

resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = aws_autoscaling_group.cms_asg.id
  lb_target_group_arn    = aws_lb_target_group.alb_tg1.arn
}

resource "aws_autoscaling_group" "cms_asg" {
  vpc_zone_identifier       = [aws_subnet.public_subnet[0].id, aws_subnet.public_subnet[1].id]
  health_check_type         = "ELB"
  #availability_zones = ["ap-south-1a, ap-south-1b"]
  target_group_arns = [aws_alb.cms_alb.arn]

  desired_capacity = "${var.desired_capacity}"
  max_size = "${var.max_size}"
  min_size = "${var.min_size}"

  #load_balancers = ["${aws_lb.cms_alb.arn}"]

  launch_template {
    id      = aws_launch_template.cms_lt.id
  }

  #Uncomment on production to enable spot instances usage
  #mixed_instances_policy {
  #  instances_distribution {
  #    on_demand_percentage_above_base_capacity = 25
  #    spot_instance_pools = 2
  #  }
  #}
}