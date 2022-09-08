## Apps
variable "region" {
  default     = "ap-south-1"
}
variable "availability_zone" {
  type        = list(any)
  default     = ["ap-south-1a", "ap-south-1b"]
}

variable "project_name" {
  default     = "cms"
}

variable "db_password" {
  description = "The password for the DB master user"
  type        = string
  sensitive   = true
}

## Networking Service
variable "key_name" {
  description = "Key name to use"
  default     = "CMS_key"
}

variable ssh_key {
  default     = "~/.ssh/id_rsa.pub"
  description = "Default pub key"
}

variable "vpc_cidr" {
  description = "CIDR block of the vpc"
  default     = "10.0.0.0/16"
}

variable "public_subnets_cidr" {
  type        = list(any)
  description = "CIDR block for Public Subnet"
  default     = ["10.0.1.0/24", "10.0.5.0/24"]
}
variable "private_subnets_cidr" {
  type        = list(any)
  description = "CIDR block for Private Subnet"
  default     = ["10.0.10.0/24", "10.0.20.0/24"]
}
## Apps
variable "desired_capacity" {
  description = "Number of intances to start initially"
  default     = "1"
}

variable "max_size" {
  description = "Max number of intances to upscale"
  default     = "3"
}

variable "min_size" {
  description = "Minimum number of instances for the Autoscaling group"
  default     = "1"
}