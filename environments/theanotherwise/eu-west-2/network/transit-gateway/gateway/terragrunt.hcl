include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}//modules/transit_gateway"
}

inputs = {
  transit_gateway = {
    description                     = "primary eu-west-2"
    default_route_table_association = "enable"
    default_route_table_propagation = "enable"
    dns_support                     = "enable"
    vpn_ecmp_support                = "enable"
    tags = {
      Name = "primary-eu-west-2"
    }
  }
}
