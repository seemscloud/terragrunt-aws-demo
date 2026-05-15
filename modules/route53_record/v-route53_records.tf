variable "route53_records" {
  type = map(object({
    zone_id = string
    name    = string
    type    = optional(string, "CNAME")
    ttl     = optional(number, 60)
    records = list(string)
  }))
}
