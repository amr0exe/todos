output "security_group_id" {
  description = "The ID of the security Group created for the ALB"
  value       = aws_security_group.lobl.id
}

output "alb_dns_name" {
  description = "The DNS name of the load balancer"
  value       = aws_alb.tf-web.dns_name
}

output "alb_zone_id" {
  description = "hosted zone id of load balancer"
  value       = aws_alb.tf-web.zone_id
}
