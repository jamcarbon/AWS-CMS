resource "aws_db_parameter_group" "wordpress" {
  count = "${var.enabled ? 1 : 0}"

  name   = "${var.meta.project_slug}-${var.meta.environment}-wordpress-rds-parameter-group"
  family = "${var.app_config.rds.engine}${var.app_config.rds.engine_version}"

  parameter {
    name  = "character_set_server"
    value = "utf8"
  }

  parameter {
    name  = "character_set_client"
    value = "utf8"
  }

  tags = merge(var.meta.project_tags, {
    "Name" : "${var.meta.project_slug}-${var.meta.environment}-wordpress-rds-parameter-group"
    "Environment" : var.meta.environment
    "Project" : var.meta.project_name
  })
}
