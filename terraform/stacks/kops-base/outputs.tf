output "hosted_zone" {
  value = "${data.aws_route53_zone.subdomain_hosted_zone.name}"
}

output "hosted_zone_id" {
  value = "${data.aws_route53_zone.subdomain_hosted_zone.id}"
}

output "bucket" {
//  value = "cluster.k8s.${data.aws_route53_zone.subdomain_hosted_zone.name}"
  value = "cluster.dev.dappest.co"
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = "${module.vpc.vpc_id}"
}

# CIDR blocks
output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = ["${module.vpc.vpc_cidr_block}"]
}

//output "vpc_ipv6_cidr_block" {
//  description = "The IPv6 CIDR block"
//  value       = ["${module.vpc.vpc_ipv6_cidr_block}"]
//}

# Subnets
output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = ["${module.vpc.private_subnets}"]
}

output "private_subnets_cidr_blocks" {
  description = "List of cidr_blocks of private subnets"
  value       = ["${module.vpc.private_subnets_cidr_blocks}"]
}

output "private_subnet_azs" {
  description = "List of availability zones of private subnets"
  value       = ["${module.vpc.private_subnet_azs}"]
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = ["${module.vpc.public_subnets}"]
}

output "public_subnets_cidr_blocks" {
  description = "List of cidr_blocks of public subnets"
  value       = ["${module.vpc.public_subnets_cidr_blocks}"]
}

output "public_subnet_azs" {
  description = "List of availability zones of public subnets"
  value       = ["${module.vpc.public_subnet_azs}"]
}

output "database_subnets" {
  description = "List of IDs of database subnets"
  value       = ["${module.vpc.database_subnets}"]
}

output "database_subnets_cidr_blocks" {
  description = "List of cidr_blocks of database subnets"
  value       = ["${module.vpc.database_subnets_cidr_blocks}"]
}

# NAT gateways
output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = ["${module.vpc.nat_public_ips}"]
}