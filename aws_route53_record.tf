resource "aws_route53_record" "load-balancer" {
  zone_id = "${var.dns_zone_id}"
  name    = "${var.dns_name}"
  type    = "A"

  alias {
    evaluate_target_health = true
    name                   = "${aws_alb.jenkins_master_alb.dns_name}"
    zone_id                = "${aws_alb.jenkins_master_alb.zone_id}"
  }
}
