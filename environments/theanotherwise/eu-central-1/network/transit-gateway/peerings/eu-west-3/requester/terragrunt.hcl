include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}//modules/transit_gateway_peering_attachment"
}

locals {
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  account_id   = local.account_vars.locals.account_id
}

dependency "transit_gateway" {
  config_path = "../../../gateway"

  mock_outputs = {
    transit_gateway_id = "tgw-0123456789abcdef0"
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "destroy"]
  mock_outputs_merge_strategy_with_state  = "deep_map_only"
}

dependency "peer_transit_gateway" {
  config_path = "../../../../../../eu-west-3/network/transit-gateway/gateway"

  mock_outputs = {
    transit_gateway_id = "tgw-0123456789abcdef3"
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "destroy"]
  mock_outputs_merge_strategy_with_state  = "deep_map_only"
}

inputs = {
  transit_gateway_peering_attachment = {
    peer_account_id         = local.account_id
    peer_region             = "eu-west-3"
    peer_transit_gateway_id = dependency.peer_transit_gateway.outputs.transit_gateway_id
    transit_gateway_id      = dependency.transit_gateway.outputs.transit_gateway_id
    tags = {
      Name = "eu-central-1-hub-to-eu-west-3"
    }
  }
}
