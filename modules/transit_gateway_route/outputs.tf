output "transit_gateway_route_ids" {
  value = {
    for key, route in aws_ec2_transit_gateway_route.this : key => route.id
  }
}
