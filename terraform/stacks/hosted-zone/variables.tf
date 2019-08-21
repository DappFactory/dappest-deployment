variable "tags" {
  type        = "map"
  description = ""
}

variable "main_zone" {
  description = "The zone branch a hosted zone from"
}

variable "subdomain" {
  description = "The sub-domain that extends the main_zone"
}

variable "update_ns_in_main_zone" {
  description = "Update NS records in Route53 main zone"
  default     = true
}