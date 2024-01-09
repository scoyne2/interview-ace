resource "aws_acm_certificate" "api" {
  domain_name       = "websocket.crackingthedataengineeringinterview.com"
  validation_method = "DNS"
}

data "aws_route53_zone" "public" {
  name         = "crackingthedataengineeringinterview.com"
  private_zone = false
}

resource "aws_route53_record" "api-validation" {
  for_each = {
    for dvo in aws_acm_certificate.api.domain_validation_options : dvo.domain_name => {
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
  zone_id         = data.aws_route53_zone.public.zone_id
}

resource "aws_acm_certificate_validation" "api" {
  certificate_arn         = aws_acm_certificate.api.arn
  validation_record_fqdns = [for record in aws_route53_record.api-validation : record.fqdn]
}

output "aws-acm-certificate-arn" {
  value = resource.aws_acm_certificate.api.arn
}

output "public-zone-id" {   
    value = data.aws_route53_zone.public.zone_id
}