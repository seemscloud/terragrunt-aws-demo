variable "transit_gateway_routes" {
  type = map(object({
    destination_cidr_block         = string
    transit_gateway_attachment_id  = string
    transit_gateway_route_table_id = string
  }))
}
