include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}//modules/transit_gateway_route"
}

dependency "transit_gateway" {
  config_path = "../gateway"

  mock_outputs = {
    transit_gateway_association_default_route_table_id = "tgw-rtb-0123456789abcdef0"
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "destroy"]
  mock_outputs_merge_strategy_with_state  = "deep_map_only"
}

dependency "peer_hub" {
  config_path = "../peerings/eu-central-1/accepter"

  mock_outputs = {
    transit_gateway_peering_attachment_id = "tgw-attach-0123456789abcdef0"
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "destroy"]
  mock_outputs_merge_strategy_with_state  = "deep_map_only"
}

locals {
  eu_west_1_cidrs = ["10.1.10.0/24", "10.1.11.0/24", "10.1.12.0/24", "10.1.20.0/24", "10.1.21.0/24", "10.1.22.0/24"]
  eu_west_3_cidrs = ["10.3.10.0/24", "10.3.11.0/24", "10.3.12.0/24", "10.3.20.0/24", "10.3.21.0/24", "10.3.22.0/24"]
}

inputs = {
  transit_gateway_routes = merge(
    {
      for cidr in local.eu_west_1_cidrs : "eu-west-1-${replace(replace(cidr, ".", "-"), "/", "-")}" => {
        destination_cidr_block         = cidr
        transit_gateway_attachment_id  = dependency.peer_hub.outputs.transit_gateway_peering_attachment_id
        transit_gateway_route_table_id = dependency.transit_gateway.outputs.transit_gateway_association_default_route_table_id
      }
    },
    {
      for cidr in local.eu_west_3_cidrs : "eu-west-3-${replace(replace(cidr, ".", "-"), "/", "-")}" => {
        destination_cidr_block         = cidr
        transit_gateway_attachment_id  = dependency.peer_hub.outputs.transit_gateway_peering_attachment_id
        transit_gateway_route_table_id = dependency.transit_gateway.outputs.transit_gateway_association_default_route_table_id
      }
    }
  )
}
