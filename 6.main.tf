provider "aws" {
  region = "${var.region}"
}

data "aws_ami" "image" {
  most_recent = true
  owners      = ["${var.image_owner}"] #137112412989   AWS AMI 
}

data "template_file" "init" {
  template = "${file("${path.module}/scripts/wordpress.sh")}"
}


resource "aws_launch_template" "cms_lt" {
  name_prefix            = "${var.project_name}"
  image_id               = "${data.aws_ami.image.id}"
  instance_type          = "t2.micro"
  key_name               = "${aws_key_pair.asg-key-pair.key_name}"
  vpc_security_group_ids = ["${aws_security_group.asg-sec-group.id}"]
  user_data = "${base64encode(data.template_file.init.rendered)}"
  
}

resource "aws_autoscaling_group" "cms_asg" {
  vpc_zone_identifier       = [aws_subnet.private-us-east-1a.id, aws_subnet.private-us-east-1b.id, aws_subnet.public-us-east-1a.id, aws_subnet.public-us-east-1b.id]
  health_check_type         = "ELB"

  desired_capacity = "${var.desired_capacity}"
  max_size = "${var.max_size}"
  min_size = "${var.min_size}"

  mixed_instances_policy {
    launch_template {
      launch_template_specification {
        launch_template_id = "${aws_launch_template.cms_lt.id}"
      }

      override {
        instance_type     = "c4.large"
        weighted_capacity = "3"
      }

      override {
        instance_type     = "c3.large"
        weighted_capacity = "2"
      }
    }
  }
}