
data "aws_route53_zone" "primary_zone" {
  name = var.domain_names[0]
}

# create A record aliases pointing to "lb_dns_name"
resource "aws_route53_record" "www" {
  zone_id  = data.aws_route53_zone.primary_zone.zone_id
  for_each = toset(var.domain_names)
  name     = each.value
  type     = "A"

  alias {
    name                   = var.lb_dns_name
    zone_id                = var.lb_zone_id
    evaluate_target_health = true
  }
}
