resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  appliance_mode_support                          = var.transit_gateway_vpc_attachment.appliance_mode_support
  dns_support                                     = var.transit_gateway_vpc_attachment.dns_support
  ipv6_support                                    = var.transit_gateway_vpc_attachment.ipv6_support
  subnet_ids                                      = var.transit_gateway_vpc_attachment.subnet_ids
  transit_gateway_default_route_table_association = var.transit_gateway_vpc_attachment.transit_gateway_default_route_table_association
  transit_gateway_default_route_table_propagation = var.transit_gateway_vpc_attachment.transit_gateway_default_route_table_propagation
  transit_gateway_id                              = var.transit_gateway_vpc_attachment.transit_gateway_id
  vpc_id                                          = var.transit_gateway_vpc_attachment.vpc_id

  tags = merge(var.tags, var.transit_gateway_vpc_attachment.tags)
}
