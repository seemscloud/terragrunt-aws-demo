output "transit_gateway_arn" {
  value = aws_ec2_transit_gateway.this.arn
}

output "transit_gateway_association_default_route_table_id" {
  value = aws_ec2_transit_gateway.this.association_default_route_table_id
}

output "transit_gateway_id" {
  value = aws_ec2_transit_gateway.this.id
}

output "transit_gateway_owner_id" {
  value = aws_ec2_transit_gateway.this.owner_id
}

output "transit_gateway_propagation_default_route_table_id" {
  value = aws_ec2_transit_gateway.this.propagation_default_route_table_id
}
