## Networking Outputs
output "elb_id" {
  description = "The ID of the Wordpress ELB"
  value       = join("", aws_elb.wordpress.*.id)
}
