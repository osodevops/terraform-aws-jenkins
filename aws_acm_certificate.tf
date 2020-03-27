resource "aws_acm_certificate" "load-balancer" {
  domain_name               = "${aws_route53_record.load-balancer.fqdn}"
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags       = var.common_tags
  depends_on = ["aws_route53_record.load-balancer"]
}

//resource "aws_route53_record" "load-balancer_cert_validation" {
//  count   = "${length(local.certificate_subject_alt_names) + 1}"
//  name    = "${lookup(local.dvo[count.index], "resource_record_name")}"
//  type    = "${lookup(local.dvo[count.index], "resource_record_type")}"
//  zone_id = "${var.dns_zone_id}"
//  records = ["${lookup(local.dvo[count.index], "resource_record_value")}"]
//  ttl     = 60
//
//  depends_on = ["aws_acm_certificate.load-balancer"]
//}
//
//resource "aws_acm_certificate_validation" "load-balancer" {
//  count                   = "${length(local.certificate_subject_alt_names) + 1}"
//  certificate_arn         = "${aws_acm_certificate.load-balancer.arn}"
//  validation_record_fqdns = ["${aws_route53_record.load-balancer_cert_validation.*.fqdn}"]
//}

locals {
  dvo = "${flatten(aws_acm_certificate.load-balancer.*.domain_validation_options)}"
}
