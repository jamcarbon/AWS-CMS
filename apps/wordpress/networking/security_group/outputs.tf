## Networking Outputs
output "elb_sg_id" {
  description = "The ID of the Wordpress ELB Security Group"
  value       = join("", aws_security_group.wordpress_elb.*.id)
}

output "instance_sg_id" {
  description = "The ID of the Wordpress Instance Security Group"
  value       = join("", aws_security_group.wordpress_instance.*.id)
}

output "database_sg_id" {
  description = "The ID of the Wordpress Database Security Group"
  value       = join("", aws_security_group.wordpress_database.*.id)
}
