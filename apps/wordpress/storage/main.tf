## RDS
module "rds" {
  source = "./rds"

  ## Networking Service
  networking_module = var.networking_module

  ## Application Config
  enabled    = var.enabled
  app_config = var.app_config

  ## Meta
  meta = var.meta
}
