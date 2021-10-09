resource "aws_route53_record" "public" {
  count = var.public_domain == null ? 0 : 1
  provider = aws.dns
  zone_id = var.route53_zone_id
  name = var.public_domain
  type = "A"
  ttl = "300"
  records = [for ip in azurerm_public_ip.this : ip.ip_address]
}

resource "aws_route53_record" "private" {
  count = var.host_count
  provider = aws.dns
  zone_id = var.route53_zone_id
  name = "${var.rg.name}-${var.name}${format("%04.0f", count.index + 1)}.${var.private_domain}"
  type = "A"
  ttl = "300"
  records = [
    azurerm_network_interface.this[count.index].private_ip_address
  ]
}