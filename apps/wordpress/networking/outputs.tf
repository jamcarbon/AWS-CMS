## Networking Outputs
output "elb_sg_id" {
  description = "The ID of the Wordpress ELB Security Group"
  value       = module.security_group.elb_sg_id
}

output "instance_sg_id" {
  description = "The ID of the Wordpress Instance Security Group"
  value       = module.security_group.instance_sg_id
}

output "database_sg_id" {
  description = "The ID of the Wordpress Database Security Group"
  value       = module.security_group.database_sg_id
}
