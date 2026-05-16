resource "aws_ec2_transit_gateway_peering_attachment" "this" {
  peer_account_id         = var.transit_gateway_peering_attachment.peer_account_id
  peer_region             = var.transit_gateway_peering_attachment.peer_region
  peer_transit_gateway_id = var.transit_gateway_peering_attachment.peer_transit_gateway_id
  transit_gateway_id      = var.transit_gateway_peering_attachment.transit_gateway_id

  tags = merge(var.tags, var.transit_gateway_peering_attachment.tags)
}
