# Uncomment if you need to create hosted zone (see README)
# resource "aws_route53_zone" "domain_zone" {
#   name = var.domain_name
# }

resource "aws_route53_record" "domain_record" {
  # zone_id = aws_route53_zone.domain_zone.zone_id
  zone_id = var.hosted_zone_id
  name    = var.domain_name
  type    = "A"
  alias {
    name                   = aws_lb.wu-tang.dns_name
    zone_id                = aws_lb.wu-tang.zone_id
    evaluate_target_health = true
  }
}
