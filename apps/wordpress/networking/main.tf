## Security Group
module "security_group" {
  source = "./security_group"

  ## Networking Service
  networking_module = var.networking_module

  ## Application Config
  app_config = var.app_config

  ## Meta
  meta = var.meta
}
