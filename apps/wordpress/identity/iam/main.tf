resource "aws_iam_role" "wordpress_instance" {
  count = "${var.app_config.enabled ? 1 : 0}"

  name = "${var.meta.project_slug}-${var.meta.environment}-wordpress-iam-role"

  assume_role_policy = file("${path.module}/files/wordpress_instance_assume_role_policy.json")
}

resource "aws_iam_instance_profile" "wordpress_instance" {
  count = "${var.app_config.enabled ? 1 : 0}"

  name = "${var.meta.project_slug}-${var.meta.environment}-wordpress-instance-profile"
  role = aws_iam_role.wordpress_instance[count.index].name
}
