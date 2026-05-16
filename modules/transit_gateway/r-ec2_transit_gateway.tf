resource "aws_ec2_transit_gateway" "this" {
  amazon_side_asn                 = var.transit_gateway.amazon_side_asn
  auto_accept_shared_attachments  = var.transit_gateway.auto_accept_shared_attachments
  default_route_table_association = var.transit_gateway.default_route_table_association
  default_route_table_propagation = var.transit_gateway.default_route_table_propagation
  description                     = var.transit_gateway.description
  dns_support                     = var.transit_gateway.dns_support
  vpn_ecmp_support                = var.transit_gateway.vpn_ecmp_support

  tags = merge(var.tags, var.transit_gateway.tags)
}
