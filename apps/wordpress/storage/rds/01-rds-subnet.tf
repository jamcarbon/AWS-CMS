resource "aws_db_subnet_group" "wordpress" {
  count = "${var.enabled ? 1 : 0}"

  name       = "${var.meta.project_slug}-${var.meta.environment}-wordpress-rds-subnet"
  subnet_ids = var.networking_module.private_subnets

  tags = merge(var.meta.project_tags, {
    "Name" : "${var.meta.project_slug}-${var.meta.environment}-wordpress-rds-subnet"
    "Environment" : var.meta.environment
    "Project" : var.meta.project_name
  })
}
