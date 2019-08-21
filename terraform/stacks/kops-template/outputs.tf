output "kops_config" {
  value = "${data.template_file.kops_config.rendered}"
}