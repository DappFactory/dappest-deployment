terraform {
  backend "s3" {}
}

provider "aws" {
  region  = "${var.region}"
  profile = "${var.profile}"
}

# =-=-=-=-=-=-=-=-=-=-=-=-=-=-    KOPS Base   =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

# Hosted zone is already created on AWS

locals {
  # Add stack name to all tags to easily id aws-resources with tf-stack
  tags = "${merge(var.tags, map("tf-stack", "dappest:kops-base"))}"
}

data "aws_route53_zone" "subdomain_hosted_zone" {
  name         = "${var.subdomain_hosted_zone}"
  private_zone = false
}

module "s3_bucket" {
  source = "../s3"
  bucket = "cluster.${replace(data.aws_route53_zone.subdomain_hosted_zone.name, "/[.]$/", "")}"
  acl    = "${var.acl}"
  tags   = "${local.tags}"
}

module "vpc" {
  source = "../vpc"

  name = "dappest-vpc"

  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  database_subnets  = ["10.0.201.0/24", "10.0.202.0/24", "10.0.203.0/24"]

  assign_generated_ipv6_cidr_block = true

  enable_nat_gateway = true
  single_nat_gateway = true

  public_subnet_tags = {
    Name = "dappest-public-subnets"
  }

  tags = {
    Owner       = "dappest-dev"
    Environment = "development"
  }

  vpc_tags = {
    Name = "dappest-vpc"
  }
}

module "database_sg" {
  source = "../sg"

  name        = "database-sg"
  description = "Security group for database"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress_cidr_blocks = ["${module.vpc.vpc_cidr_block}"]
  ingress_with_cidr_blocks = [
    {
      rule        = "postgresql-tcp"
      cidr_blocks = "${module.vpc.private_subnets_cidr_blocks[0]}"
    },
    {
      rule        = "postgresql-tcp"
      cidr_blocks = "${module.vpc.private_subnets_cidr_blocks[1]}"
    },
    {
      rule        = "postgresql-tcp"
      cidr_blocks = "${module.vpc.private_subnets_cidr_blocks[2]}"
    },
  ]
  ingress_with_self = [
    {
    "rule" = "all-all"
    },
  ]
  egress_rules = [
    "all-all"
  ]
}

# =-=-=-=-=-=-=-=-=-=-=-=-=-=-    RDS   =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

module "db" {
  source = "../rds"

  identifier = "dappest-rds"

  engine            = "postgres"
  engine_version    = "10.3"
  instance_class    = "db.t2.micro"
  allocated_storage = 20
  storage_encrypted = false

  # kms_key_id        = "arm:aws:kms:<region>:<account id>:key/<kms key id>"
  name = "devdb"

  # NOTE: Do NOT use 'user' as the value for 'username' as it throws:
  # "Error creating DB Instance: InvalidParameterValue: MasterUsername
  # user cannot be used as it is a reserved word used by the engine"
  username = ""

  password = ""
  port     = "5432"

  vpc_security_group_ids = ["${module.database_sg.this_security_group_id}"]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  # disable backups to create DB faster
  backup_retention_period = 0

  tags = {
    Owner       = "dappest-dev"
    Environment = "development"
  }

  # DB subnet group
  subnet_ids = ["${module.vpc.database_subnets}"]

  # DB parameter group
  family = "postgres10"

  # DB option group
  major_engine_version = "10"

  # Snapshot name upon DB deletion
  final_snapshot_identifier = "devdb"
}