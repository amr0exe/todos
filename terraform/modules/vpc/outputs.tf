output "vpc_id" {
  description = "ID of freshly created VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "list of public_subnets inside VPC"
  value       = module.vpc.public_subnets
}
