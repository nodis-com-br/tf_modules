resource "aws_ses_domain_identity" "this" {
  provider = aws.current
  domain = var.domain
}

resource "aws_ses_domain_dkim" "this" {
  provider = aws.current
  domain = aws_ses_domain_identity.this.domain
}

resource "aws_ses_email_identity" "this" {
  provider = aws.current
  email = var.email_identity
}

module "dns_txt_record" {
  source = "../aws_route53_record"
  route53_zone = var.route53_zone
  name = "_amazonses.nodis.com.br"
  type = "TXT"
  records = [
    aws_ses_domain_identity.this.verification_token
  ]
  providers = {
    aws.current = aws.dns
  }
}

module "dns_cname_record" {
  source = "../aws_route53_record"
  count = 3
  route53_zone = var.route53_zone
  name = "${element(aws_ses_domain_dkim.this.dkim_tokens, count.index)}._domainkey.nodis.com.br"
  type = "CNAME"
  ttl = "600"
  records = [
    "${element(aws_ses_domain_dkim.this.dkim_tokens, count.index)}.dkim.amazonses.com"
  ]
  providers = {
    aws.dns = aws.dns
  }
}