output "instance_profile_arn" {
  description = "The ARN of the Wordpress IAM Instance Profile"
  value       = join("", aws_iam_instance_profile.wordpress_instance.*.arn)
}
