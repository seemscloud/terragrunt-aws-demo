variable "transit_gateway_peering_attachment_accepter" {
  type = object({
    transit_gateway_attachment_id = string
    tags                          = optional(map(string), {})
  })
}
