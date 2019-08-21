variable "profile" {
  description = "AWS Profile"
}

variable "region" {
  description = "AWS Region"
}

//variable "subdomain" {
//  description = "The hosted zone prefix for all clusters. (ie k8s)"
//  default     = "k8s"
//}

variable "subdomain_hosted_zone" {
  description = "The FQDN of an existing hosted zone in the aws account"
}

//variable "subdomain_hosted_zone_id" {
//  description = "The ID of the subdomain hosted zone"
//}

variable "acl" {
  description = "The bucket acl"
  default     = "private"
}

variable "tags" {
  description = "Resource tags"
  type        = "map"
}