output "transit_gateway_peering_attachment_id" {
  value = aws_ec2_transit_gateway_peering_attachment.this.id
}

output "transit_gateway_peering_attachment_state" {
  value = aws_ec2_transit_gateway_peering_attachment.this.state
}
