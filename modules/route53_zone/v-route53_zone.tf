variable "route53_zone" {
  type = object({
    name = string
    vpcs = list(object({
      vpc_id     = string
      vpc_region = string
    }))
    tags = optional(map(string), {})
  })

  validation {
    condition     = length(var.route53_zone.name) > 0
    error_message = "Route53 zone name is required."
  }

  validation {
    condition     = length(var.route53_zone.vpcs) > 0
    error_message = "Private Route53 zone requires at least one VPC."
  }
}
