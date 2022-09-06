## Apps
variable "region" {
  default     = "ap-south-1"
}

variable "project_name" {
  default     = "cms"
}

## Networking Service
variable "key_name" {
  description = "Key name to use"
  default     = "CMS_key"
}
## Apps
variable "image_owner" {
  description = "image owner"
  default     = "878522837758"
}

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