output "instance_profile_arn" {
  description = "The ARN of the Wordpress IAM Instance Profile"
  value       = module.iam.instance_profile_arn
}
