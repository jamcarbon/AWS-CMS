## IAM
module "iam" {
  source = "./iam"

  ## Application Config
  app_config = var.app_config

  ## Meta
  meta = var.meta
}
