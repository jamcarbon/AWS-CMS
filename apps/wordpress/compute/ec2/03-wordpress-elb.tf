resource "aws_autoscaling_attachment" "wordpress_elb_attachment" {
  count = "${var.enabled ? 1 : 0}"

  autoscaling_group_name = "${aws_autoscaling_group.wordpress_asg[count.index].id}"
  elb                    = var.app_config.elb.elb_id
}
