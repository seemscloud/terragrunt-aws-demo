variable "transit_gateway_vpc_attachment" {
  type = object({
    appliance_mode_support                          = optional(string)
    dns_support                                     = optional(string)
    ipv6_support                                    = optional(string)
    subnet_ids                                      = list(string)
    transit_gateway_default_route_table_association = optional(bool)
    transit_gateway_default_route_table_propagation = optional(bool)
    transit_gateway_id                              = string
    vpc_id                                          = string
    tags                                            = optional(map(string), {})
  })
}
