## Wordpress
module "wordpress" {
  source = "./wordpress"

  ## Networking Service
  networking_module = var.networking_module

  ## Application Config
  app_config = var.apps.wordpress

  ## Meta
  meta = var.meta
}
