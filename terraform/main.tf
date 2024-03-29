provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

module "vpc" {
  source = "stacks/vpc"

  name = "terraform-vpc"

  cidr = "10.0.0.0/16"

  azs = ["us-east-1a", "us-east-1b", "us-east-1c"]

  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]

  public_subnets = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  database_subnets    = ["10.10.21.0/24", "10.10.22.0/24", "10.10.23.0/24"]

  assign_generated_ipv6_cidr_block = true

  enable_nat_gateway = true
  single_nat_gateway = true

  public_subnet_tags = {
    Name = "terraform-public"
  }

  tags = {
    Owner = "user"
    Environment = "dev"
  }

  vpc_tags = {
    Name = "terraform"
  }
}

module "postgres_sg" {
  source = "stacks/sg"

  create      = "${var.create}"
  name        = "postgres_sg"
  description = "${var.description}"
  vpc_id      = "${module.vpc.vpc_id}"
  tags        = "${var.tags}"

  ##########
  # Ingress
  ##########
  # Rules by names - open for default CIDR
  ingress_rules = ["${sort(distinct(concat(var.auto_ingress_rules, var.ingress_rules)))}"]

  # Open for self
  ingress_with_self = ["${concat(var.auto_ingress_with_self, var.ingress_with_self)}"]

  # Open to IPv4 cidr blocks
  ingress_with_cidr_blocks = ["${var.ingress_with_cidr_blocks}"]

  # Open to IPv6 cidr blocks
  ingress_with_ipv6_cidr_blocks = ["${var.ingress_with_ipv6_cidr_blocks}"]

  # Open for security group id
  ingress_with_source_security_group_id = ["${var.ingress_with_source_security_group_id}"]

  # Default ingress CIDR blocks
  ingress_cidr_blocks      = ["${var.ingress_cidr_blocks}"]
  ingress_ipv6_cidr_blocks = ["${var.ingress_ipv6_cidr_blocks}"]

  # Default prefix list ids
  ingress_prefix_list_ids = ["${var.ingress_prefix_list_ids}"]

  ###################
  # Computed Ingress
  ###################
  # Rules by names - open for default CIDR
  computed_ingress_rules = ["${sort(distinct(concat(var.auto_computed_ingress_rules, var.computed_ingress_rules)))}"]

  # Open for self
  computed_ingress_with_self = ["${concat(var.auto_computed_ingress_with_self, var.computed_ingress_with_self)}"]

  # Open to IPv4 cidr blocks
  computed_ingress_with_cidr_blocks = ["${var.computed_ingress_with_cidr_blocks}"]

  # Open to IPv6 cidr blocks
  computed_ingress_with_ipv6_cidr_blocks = ["${var.computed_ingress_with_ipv6_cidr_blocks}"]

  # Open for security group id
  computed_ingress_with_source_security_group_id = ["${var.computed_ingress_with_source_security_group_id}"]

  #############################
  # Number of computed ingress
  #############################
  number_of_computed_ingress_rules = "${var.auto_number_of_computed_ingress_rules + var.number_of_computed_ingress_rules}"

  number_of_computed_ingress_with_self                     = "${var.auto_number_of_computed_ingress_with_self + var.number_of_computed_ingress_with_self}"
  number_of_computed_ingress_with_cidr_blocks              = "${var.number_of_computed_ingress_with_cidr_blocks}"
  number_of_computed_ingress_with_ipv6_cidr_blocks         = "${var.number_of_computed_ingress_with_ipv6_cidr_blocks}"
  number_of_computed_ingress_with_source_security_group_id = "${var.number_of_computed_ingress_with_source_security_group_id}"

  #########
  # Egress
  #########
  # Rules by names - open for default CIDR
  egress_rules = ["${sort(distinct(concat(var.auto_egress_rules, var.egress_rules)))}"]

  # Open for self
  egress_with_self = ["${concat(var.auto_egress_with_self, var.egress_with_self)}"]

  # Open to IPv4 cidr blocks
  egress_with_cidr_blocks = ["${var.egress_with_cidr_blocks}"]

  # Open to IPv6 cidr blocks
  egress_with_ipv6_cidr_blocks = ["${var.egress_with_ipv6_cidr_blocks}"]

  # Open for security group id
  egress_with_source_security_group_id = ["${var.egress_with_source_security_group_id}"]

  # Default egress CIDR blocks
  egress_cidr_blocks      = ["${var.egress_cidr_blocks}"]
  egress_ipv6_cidr_blocks = ["${var.egress_ipv6_cidr_blocks}"]

  # Default prefix list ids
  egress_prefix_list_ids = ["${var.egress_prefix_list_ids}"]

  ##################
  # Computed Egress
  ##################
  # Rules by names - open for default CIDR
  computed_egress_rules = ["${sort(distinct(concat(var.auto_computed_egress_rules, var.computed_egress_rules)))}"]

  # Open for self
  computed_egress_with_self = ["${concat(var.auto_computed_egress_with_self, var.computed_egress_with_self)}"]

  # Open to IPv4 cidr blocks
  computed_egress_with_cidr_blocks = ["${var.computed_egress_with_cidr_blocks}"]

  # Open to IPv6 cidr blocks
  computed_egress_with_ipv6_cidr_blocks = ["${var.computed_egress_with_ipv6_cidr_blocks}"]

  # Open for security group id
  computed_egress_with_source_security_group_id = ["${var.computed_egress_with_source_security_group_id}"]

  #############################
  # Number of computed egress
  #############################
  number_of_computed_egress_rules = "${var.auto_number_of_computed_egress_rules + var.number_of_computed_egress_rules}"

  number_of_computed_egress_with_self                     = "${var.auto_number_of_computed_egress_with_self + var.number_of_computed_egress_with_self}"
  number_of_computed_egress_with_cidr_blocks              = "${var.number_of_computed_egress_with_cidr_blocks}"
  number_of_computed_egress_with_ipv6_cidr_blocks         = "${var.number_of_computed_egress_with_ipv6_cidr_blocks}"
  number_of_computed_egress_with_source_security_group_id = "${var.number_of_computed_egress_with_source_security_group_id}"
}
