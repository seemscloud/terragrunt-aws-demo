include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}//modules/transit_gateway_peering_attachment_accepter"
}

dependency "requester" {
  config_path = "../../../../../../eu-central-1/network/transit-gateway/peerings/eu-west-3/requester"

  mock_outputs = {
    transit_gateway_peering_attachment_id = "tgw-attach-0123456789abcdef2"
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "destroy"]
  mock_outputs_merge_strategy_with_state  = "deep_map_only"
}

inputs = {
  transit_gateway_peering_attachment_accepter = {
    transit_gateway_attachment_id = dependency.requester.outputs.transit_gateway_peering_attachment_id
    tags = {
      Name = "eu-central-1-hub-to-eu-west-3"
    }
  }
}
