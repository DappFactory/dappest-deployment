provider "aws" {
  region  = "${var.region}"
  profile = "${var.profile}"
}

# =-=-=-=-=-=-=-=-=-=-=-=-=-=- Data Resources =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Pull in VPC data
data "terraform_remote_state" "vpc" {
  backend = "s3"

  config {
    bucket  = "${var.vpc_remote_state_bucket}"
    key     = "${var.vpc_remote_state_key}"
    region  = "us-east-1"
    profile = "${var.profile}"
  }
}

# Pull in kops-base data
data "terraform_remote_state" "kops_base" {
  backend = "s3"

  config {
    bucket  = "${var.kops_base_remote_state_bucket}"
    key     = "${var.kops_base_remote_state_key}"
    region  = "us-east-1"
    profile = "${var.profile}"
  }
}

data "template_file" "etcd_members" {
  template = "${file("${path.module}/files/etcd_members.tpl")}"
  count    = "${var.master_count}"

  vars {
    number = "${count.index +1}"
  }
}

data "template_file" "pri_subnets" {
  template = "${file("${path.module}/files/vpc-pri-subnets.tpl")}"
  count    = "${length(data.terraform_remote_state.vpc.private_subnets)}"

  vars {
    pri_cidr      = "${data.terraform_remote_state.vpc.private_subnets_cidr_blocks[count.index]}"
    pri_subnet_id = "${data.terraform_remote_state.vpc.private_subnets[count.index]}"
    pri_subnet_az = "${data.terraform_remote_state.vpc.private_subnet_azs[count.index]}"
    number        = "${count.index +1}"
  }
}

data "template_file" "pub_subnets" {
  template = "${file("${path.module}/files/vpc-pub-subnets.tpl")}"
  count    = "${length(data.terraform_remote_state.vpc.public_subnets)}"

  vars {
    pub_cidr      = "${data.terraform_remote_state.vpc.public_subnets_cidr_blocks[count.index]}"
    pub_subnet_id = "${data.terraform_remote_state.vpc.public_subnets[count.index]}"
    pub_subnet_az = "${data.terraform_remote_state.vpc.public_subnet_azs[count.index]}"
    number        = "${count.index +1}"
  }
}

data "template_file" "master_instance_group" {
  template = "${file("${path.module}/files/master-instance-group.tpl")}"
  count    = "${var.master_count}"

  vars {
    cluster_name_prefix  = "${var.cluster_name_prefix}"
    hosted_zone          = "${replace(data.terraform_remote_state.kops_base.hosted_zone, "/[.]$/", "")}"
    private_subnets_list = "${element(data.template_file.pri_subnets_list.*.rendered, count.index)}"
    number               = "${count.index +1}"
  }
}

data "template_file" "pri_subnets_list" {
  template = "${file("${path.module}/files/vpc-pri-subnets-list.tpl")}"
  count    = "${length(data.terraform_remote_state.vpc.private_subnets)}"

  vars {
    number = "${count.index +1}"
  }
}

data "template_file" "kops_config" {
  template = "${file("${path.module}/files/${var.kops_conf_template_name}.tpl")}"

  vars = {
    HOSTED_ZONE           = "${replace(data.terraform_remote_state.kops_base.hosted_zone, "/[.]$/", "")}"
    HOSTED_ZONE_ID        = "${data.terraform_remote_state.kops_base.hosted_zone_id}"
    CLUSTER_NAME_PREFIX   = "${var.cluster_name_prefix}"
    ETCD_MEMBERS          = "${join("", data.template_file.etcd_members.*.rendered)}"
    VPC_ID                = "${data.terraform_remote_state.vpc.vpc_id}"
    VPC_CIDR_BLOCK        = "${data.terraform_remote_state.vpc.vpc_cidr_block[0]}"
    PRIVATE_SUBNETS       = "${join("", data.template_file.pri_subnets.*.rendered)}"
    PUBLIC_SUBNETS        = "${join("", data.template_file.pub_subnets.*.rendered)}"
    MASTER_INSTANCE_GROUP = "${join("", data.template_file.master_instance_group.*.rendered)}"
    PRIVATE_SUBNETS_LIST  = "${join("", data.template_file.pri_subnets_list.*.rendered)}"
  }
}

resource "local_file" "kops_config" {
  content  = "${data.template_file.kops_config.rendered}"
  filename = "${path.module}/${var.kops_conf_template_name}.config"
}