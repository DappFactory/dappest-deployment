variable "access_key" {
}

variable "secret_key" {
}

variable "region" {
  default = "us-east-1"
}

variable "identifier" {
  default     = "dappest-test"
  description = "Identifier for your DB"
}

variable "storage" {
  default     = "10"
  description = "Storage size in GB"
}

variable "engine" {
  default     = "postgres"
  description = "Engine type, example values mysql, postgres"
}

variable "engine_version" {
  description = "Engine version"

  default = "10.4"

}

variable "instance_class" {
  default     = "db.t2.micro"
  description = "Instance class"
}

variable "db_name" {
  default     = "dappest"
  description = "db name"
}

variable "username" {
  default     = "dev"
  description = "User name"
}

variable "password" {
  default     = ""
  description = "password, provide through your ENV variables"
}

#################
# Security group
#################
variable "create" {
  description = "Whether to create security group and all rules"
  default     = true
}

variable "vpc_id" {
  description = "ID of the VPC where to create security group"
}

variable "name" {
  description = "Name of security group"
}

variable "description" {
  description = "Description of security group"
  default     = "Security Group managed by Terraform"
}

variable "tags" {
  description = "A mapping of tags to assign to security group"
  default     = {}
}

##########
# Ingress
##########
variable "ingress_rules" {
  description = "List of ingress rules to create by name"
  default     = []
}

variable "ingress_with_self" {
  description = "List of ingress rules to create where 'self' is defined"
  default     = []
}

variable "ingress_with_cidr_blocks" {
  description = "List of ingress rules to create where 'cidr_blocks' is used"
  default     = []
}

variable "ingress_with_ipv6_cidr_blocks" {
  description = "List of ingress rules to create where 'ipv6_cidr_blocks' is used"
  default     = []
}

variable "ingress_with_source_security_group_id" {
  description = "List of ingress rules to create where 'source_security_group_id' is used"
  default     = []
}

variable "ingress_cidr_blocks" {
  description = "List of IPv4 CIDR ranges to use on all ingress rules"
  default     = []
}

variable "ingress_ipv6_cidr_blocks" {
  description = "List of IPv6 CIDR ranges to use on all ingress rules"
  default     = []
}

variable "ingress_prefix_list_ids" {
  description = "List of prefix list IDs (for allowing access to VPC endpoints) to use on all ingress rules"
  default     = []
}

###################
# Computed Ingress
###################
variable "computed_ingress_rules" {
  description = "List of computed ingress rules to create by name"
  default     = []
}

variable "computed_ingress_with_self" {
  description = "List of computed ingress rules to create where 'self' is defined"
  default     = []
}

variable "computed_ingress_with_cidr_blocks" {
  description = "List of computed ingress rules to create where 'cidr_blocks' is used"
  default     = []
}

variable "computed_ingress_with_ipv6_cidr_blocks" {
  description = "List of computed ingress rules to create where 'ipv6_cidr_blocks' is used"
  default     = []
}

variable "computed_ingress_with_source_security_group_id" {
  description = "List of computed ingress rules to create where 'source_security_group_id' is used"
  default     = []
}

variable "computed_ingress_cidr_blocks" {
  description = "List of IPv4 CIDR ranges to use on all computed ingress rules"
  default     = []
}

variable "computed_ingress_ipv6_cidr_blocks" {
  description = "List of IPv6 CIDR ranges to use on all computed ingress rules"
  default     = []
}

variable "computed_ingress_prefix_list_ids" {
  description = "List of prefix list IDs (for allowing access to VPC endpoints) to use on all computed ingress rules"
  default     = []
}

###################################
# Number of computed ingress rules
###################################
variable "number_of_computed_ingress_rules" {
  description = "Number of computed ingress rules to create by name"
  default     = 0
}

variable "number_of_computed_ingress_with_self" {
  description = "Number of computed ingress rules to create where 'self' is defined"
  default     = 0
}

variable "number_of_computed_ingress_with_cidr_blocks" {
  description = "Number of computed ingress rules to create where 'cidr_blocks' is used"
  default     = 0
}

variable "number_of_computed_ingress_with_ipv6_cidr_blocks" {
  description = "Number of computed ingress rules to create where 'ipv6_cidr_blocks' is used"
  default     = 0
}

variable "number_of_computed_ingress_with_source_security_group_id" {
  description = "Number of computed ingress rules to create where 'source_security_group_id' is used"
  default     = 0
}

variable "number_of_computed_ingress_cidr_blocks" {
  description = "Number of IPv4 CIDR ranges to use on all computed ingress rules"
  default     = 0
}

variable "number_of_computed_ingress_ipv6_cidr_blocks" {
  description = "Number of IPv6 CIDR ranges to use on all computed ingress rules"
  default     = 0
}

variable "number_of_computed_ingress_prefix_list_ids" {
  description = "Number of prefix list IDs (for allowing access to VPC endpoints) to use on all computed ingress rules"
  default     = 0
}

#########
# Egress
#########
variable "egress_rules" {
  description = "List of egress rules to create by name"
  default     = []
}

variable "egress_with_self" {
  description = "List of egress rules to create where 'self' is defined"
  default     = []
}

variable "egress_with_cidr_blocks" {
  description = "List of egress rules to create where 'cidr_blocks' is used"
  default     = []
}

variable "egress_with_ipv6_cidr_blocks" {
  description = "List of egress rules to create where 'ipv6_cidr_blocks' is used"
  default     = []
}

variable "egress_with_source_security_group_id" {
  description = "List of egress rules to create where 'source_security_group_id' is used"
  default     = []
}

variable "egress_cidr_blocks" {
  description = "List of IPv4 CIDR ranges to use on all egress rules"
  default     = ["0.0.0.0/0"]
}

variable "egress_ipv6_cidr_blocks" {
  description = "List of IPv6 CIDR ranges to use on all egress rules"
  default     = ["::/0"]
}

variable "egress_prefix_list_ids" {
  description = "List of prefix list IDs (for allowing access to VPC endpoints) to use on all egress rules"
  default     = []
}

##################
# Computed Egress
##################
variable "computed_egress_rules" {
  description = "List of computed egress rules to create by name"
  default     = []
}

variable "computed_egress_with_self" {
  description = "List of computed egress rules to create where 'self' is defined"
  default     = []
}

variable "computed_egress_with_cidr_blocks" {
  description = "List of computed egress rules to create where 'cidr_blocks' is used"
  default     = []
}

variable "computed_egress_with_ipv6_cidr_blocks" {
  description = "List of computed egress rules to create where 'ipv6_cidr_blocks' is used"
  default     = []
}

variable "computed_egress_with_source_security_group_id" {
  description = "List of computed egress rules to create where 'source_security_group_id' is used"
  default     = []
}

variable "computed_egress_cidr_blocks" {
  description = "List of IPv4 CIDR ranges to use on all computed egress rules"
  default     = ["0.0.0.0/0"]
}

variable "computed_egress_ipv6_cidr_blocks" {
  description = "List of IPv6 CIDR ranges to use on all computed egress rules"
  default     = ["::/0"]
}

variable "computed_egress_prefix_list_ids" {
  description = "List of prefix list IDs (for allowing access to VPC endpoints) to use on all computed egress rules"
  default     = []
}

##################################
# Number of computed egress rules
##################################
variable "number_of_computed_egress_rules" {
  description = "Number of computed egress rules to create by name"
  default     = 0
}

variable "number_of_computed_egress_with_self" {
  description = "Number of computed egress rules to create where 'self' is defined"
  default     = 0
}

variable "number_of_computed_egress_with_cidr_blocks" {
  description = "Number of computed egress rules to create where 'cidr_blocks' is used"
  default     = 0
}

variable "number_of_computed_egress_with_ipv6_cidr_blocks" {
  description = "Number of computed egress rules to create where 'ipv6_cidr_blocks' is used"
  default     = 0
}

variable "number_of_computed_egress_with_source_security_group_id" {
  description = "Number of computed egress rules to create where 'source_security_group_id' is used"
  default     = 0
}

variable "number_of_computed_egress_cidr_blocks" {
  description = "Number of IPv4 CIDR ranges to use on all computed egress rules"
  default     = 0
}

variable "number_of_computed_egress_ipv6_cidr_blocks" {
  description = "Number of IPv6 CIDR ranges to use on all computed egress rules"
  default     = 0
}

variable "number_of_computed_egress_prefix_list_ids" {
  description = "Number of prefix list IDs (for allowing access to VPC endpoints) to use on all computed egress rules"
  default     = 0
}

###################################
# DO NOT CHANGE THIS FILE MANUALLY
###################################

variable "auto_ingress_rules" {
  description = "List of ingress rules to add automatically"
  type        = "list"
  default     = ["postgresql-tcp"]
}

variable "auto_ingress_with_self" {
  description = "List of maps defining ingress rules with self to add automatically"
  type        = "list"

  default = [{
    "rule" = "all-all"
  }]
}

variable "auto_egress_rules" {
  description = "List of egress rules to add automatically"
  type        = "list"
  default     = ["all-all"]
}

variable "auto_egress_with_self" {
  description = "List of maps defining egress rules with self to add automatically"
  type        = "list"
  default     = []
}

# Computed
variable "auto_computed_ingress_rules" {
  description = "List of ingress rules to add automatically"
  type        = "list"
  default     = []
}

variable "auto_computed_ingress_with_self" {
  description = "List of maps defining computed ingress rules with self to add automatically"
  type        = "list"
  default     = []
}

variable "auto_computed_egress_rules" {
  description = "List of computed egress rules to add automatically"
  type        = "list"
  default     = []
}

variable "auto_computed_egress_with_self" {
  description = "List of maps defining computed egress rules with self to add automatically"
  type        = "list"
  default     = []
}

# Number of computed rules
variable "auto_number_of_computed_ingress_rules" {
  description = "Number of computed ingress rules to create by name"
  default     = 0
}

variable "auto_number_of_computed_ingress_with_self" {
  description = "Number of computed ingress rules to create where 'self' is defined"
  default     = 0
}

variable "auto_number_of_computed_egress_rules" {
  description = "Number of computed egress rules to create by name"
  default     = 0
}

variable "auto_number_of_computed_egress_with_self" {
  description = "Number of computed egress rules to create where 'self' is defined"
  default     = 0
}