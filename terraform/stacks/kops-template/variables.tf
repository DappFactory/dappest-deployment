variable "profile" {
  type        = "string"
  description = "AWS profile"
}

variable "region" {
  type        = "string"
  description = "AWS region where cluster will be created"
}

variable "master_count" {
  description = "The number of masters for the cluster. Must be an odd number"
  default     = 3
}

variable "kops_conf_template_name" {
  description = "The name of the template file--must exist in `files` directory"
}

variable "kops_base_remote_state_bucket" {
  description = "The bucket of a kops_base tfstate"
}

variable "kops_base_remote_state_key" {
  type        = "string"
  description = "The key of a kops_base tfstate"
}

variable "vpc_remote_state_bucket" {
  type        = "string"
  description = "The bucket of a vpc tfstate"
}

variable "vpc_remote_state_key" {
  type        = "string"
  description = "The key of a vpc tfstate"
}

variable "cluster_name_prefix" {
  type        = "string"
  description = "The prefix of the cluster name. For example, this can be the region shorthand. (ie usw2)"
}