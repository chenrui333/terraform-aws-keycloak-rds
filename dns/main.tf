data "aws_route53_zone" "main" {
  name         = "${var.zone_name}"
  private_zone = false
}

resource "aws_route53_record" "cname" {
  zone_id = "${data.aws_route53_zone.main.zone_id}"
  name    = "${var.public_dns_name}"
  type    = "CNAME"
  ttl     = "60"
  records = ["${var.alb_dns_name}"]
}

resource "aws_acm_certificate" "main" {
  domain_name       = "${var.public_dns_name}"
  validation_method = "DNS"
}

resource "aws_route53_record" "validation" {
  for_each = {
    for dvo in aws_acm_certificate.main.domain_validation_options : dvo.domain_name => {
      name    = dvo.resource_record_name
      record  = dvo.resource_record_value
      type    = dvo.resource_record_type
      zone_id = "${data.aws_route53_zone.main.zone_id}"
      ttl = "60"
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = each.value.zone_id
}

resource "aws_acm_certificate_validation" "main" {
  certificate_arn         = "${aws_acm_certificate.main.arn}"
  validation_record_fqdns = [for record in aws_route53_record.validation : record.fqdn]
}
