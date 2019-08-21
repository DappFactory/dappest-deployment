variable "bucket" {
  description = "AWS S3 bucket name"
}

variable "acl" {
  description = "AWS S3 canned ACL"
  default     = "private"
}

variable "tags" {
  description = "Map of tags to apply to created buckets"
  type        = "map"
  default     = {}
}