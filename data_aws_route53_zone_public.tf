data "aws_route53_zone" "public" {
  zone_id = var.dns_zone_id
  private_zone = false
}
