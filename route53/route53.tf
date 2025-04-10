resource "aws_route53_record" "dns_record" {
  zone_id = var.zone_id  ### The zone ID must be copied form the aws console in route53
  name    = var.dns_name ## Name of the registered domain in route53
  type    = "A"

  alias {
    name                   = var.apci_jupiter_alb_dns_name
    zone_id                = var.apci_jupiter_alb_zone_id ## This is the zone ID of the ALB
    evaluate_target_health = true
  }
}
