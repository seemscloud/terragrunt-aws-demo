variable "transit_gateway" {
  type = object({
    amazon_side_asn                 = optional(number)
    auto_accept_shared_attachments  = optional(string)
    default_route_table_association = optional(string)
    default_route_table_propagation = optional(string)
    description                     = optional(string)
    dns_support                     = optional(string)
    vpn_ecmp_support                = optional(string)
    tags                            = optional(map(string), {})
  })
}
