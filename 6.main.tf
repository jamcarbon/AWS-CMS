provider "aws" {
  region = "${var.region}"
}

data "template_file" "init" {
  template = "${file("${path.module}/scripts/wordpress.sh")}"
}

resource "aws_launch_template" "cms_lt" {
  name_prefix            = "${var.project_name}"
  #image_id               = "${data.aws_ami.ubuntu.id}"
  image_id               = "ami-03d57e33e3cce7b3e"
  instance_type          = "t2.micro"
  key_name               = "${aws_key_pair.asg-key-pair.key_name}"
  vpc_security_group_ids = ["${aws_security_group.asg-sec-group.id}"]
  user_data = "${base64encode(data.template_file.init.rendered)}"
  
}

resource "aws_autoscaling_group" "cms_asg" {
  vpc_zone_identifier       = [aws_subnet.public_subnet[0].id, aws_subnet.private_subnet[0].id]
  health_check_type         = "ELB"

  desired_capacity = "${var.desired_capacity}"
  max_size = "${var.max_size}"
  min_size = "${var.min_size}"

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