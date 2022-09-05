provider "aws" {
  region = "ap-south-1"
}

## Networking
module "networking" {
  source = "./modules/networking/"

  ## Networking Service
  networking_module = var.networking_module

  ## Meta
  meta = var.meta
}

## APPS
module "apps" {
  source = "./apps"

  ## Networking Service
  networking_module = module.networking

  ## Apps
  apps = var.apps

  ## Meta
  meta = var.meta
}