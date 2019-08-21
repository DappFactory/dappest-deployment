/*
      Create a hosted_zone in a public main_zone
      ------------------------------------------
*/

data "aws_route53_zone" "main_zone" {
  name         = "${var.main_zone}"
  private_zone = false
}

# --- Resources ---

resource "aws_route53_zone" "hosted_zone" {
  name = "${var.subdomain}.${var.main_zone}"
  tags = "${merge(var.tags, map("Name", format("%s-zone", var.subdomain)))}"
}

resource "aws_route53_record" "NS" {
  count   = "${var.update_ns_in_main_zone ? 1 : 0}"
  zone_id = "${data.aws_route53_zone.main_zone.zone_id}"
  name    = "${aws_route53_zone.hosted_zone.name}"
  type    = "NS"
  ttl     = "300"

  records = [
    "${aws_route53_zone.hosted_zone.name_servers.0}",
    "${aws_route53_zone.hosted_zone.name_servers.1}",
    "${aws_route53_zone.hosted_zone.name_servers.2}",
    "${aws_route53_zone.hosted_zone.name_servers.3}",
  ]
}