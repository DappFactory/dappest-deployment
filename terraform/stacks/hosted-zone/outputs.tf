output "name" {
  description = ""
  value       = "${aws_route53_zone.hosted_zone.name}"
}

output "hosted_zone_id" {
  description = ""
  value       = "${aws_route53_zone.hosted_zone.zone_id}"
}