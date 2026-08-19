resource "aws_route53_zone" "main" {
  name = "terraform.amritthapa183.com.np"

  tags = {
    Environment = "${var.environment}"
  }
}

resource "vercel_dns_record" "route53-ns" {
  count  = 4
  domain = "amritthapa183.com.np"
  name   = "terraform"
  type   = "NS"
  value  = aws_route53_zone.main.name_servers[count.index]
}

resource "aws_acm_certificate" "cert" {
  domain_name       = "terraform.amritthapa183.com.np"
  validation_method = "DNS"

  tags = {
    Environment = "${var.environment}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "rec" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.main.zone_id
}

resource "aws_route53_record" "amap" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "terraform.amritthapa183.com.np"
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_acm_certificate_validation" "valid" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.rec : record.fqdn]
}
