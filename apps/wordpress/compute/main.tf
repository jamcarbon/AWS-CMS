## ELB
module "elb" {
  source = "./elb"

  ## Networking Service
  networking_module = var.networking_module

  ## Application Config
  enabled    = var.enabled
  app_config = var.app_config

  ## Meta
  meta = var.meta
}


## EC2
module "ec2" {
  source = "./ec2"

  ## Networking Service
  networking_module = var.networking_module

  ## Application Config
  enabled = var.enabled
  app_config = merge(var.app_config, {
    "elb" : module.elb
  })

  ## Meta
  meta = var.meta
}
