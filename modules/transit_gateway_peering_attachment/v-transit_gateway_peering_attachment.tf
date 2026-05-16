variable "transit_gateway_peering_attachment" {
  type = object({
    peer_account_id         = string
    peer_region             = string
    peer_transit_gateway_id = string
    transit_gateway_id      = string
    tags                    = optional(map(string), {})
  })
}
