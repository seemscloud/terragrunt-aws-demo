include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}//modules/transit_gateway_vpc_attachment"
}

dependency "transit_gateway" {
  config_path = "../../gateway"

  mock_outputs = {
    transit_gateway_id = "tgw-0123456789abcdef0"
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "destroy"]
  mock_outputs_merge_strategy_with_state  = "deep_map_only"
}

dependency "vpc" {
  config_path = "../../../vpc/primary/vpc"

  mock_outputs = {
    vpc_id = "vpc-mock-eu-west-2"
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "destroy"]
  mock_outputs_merge_strategy_with_state  = "deep_map_only"
}

dependency "subnets" {
  config_path = "../../../vpc/primary/subnets"

  mock_outputs = {
    subnet_ids = {
      "tgw-eu-west-2a" = "subnet-mock-tgw-a"
      "tgw-eu-west-2b" = "subnet-mock-tgw-b"
      "tgw-eu-west-2c" = "subnet-mock-tgw-c"
    }
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "destroy"]
  mock_outputs_merge_strategy_with_state  = "deep_map_only"
}

inputs = {
  transit_gateway_vpc_attachment = {
    dns_support = "enable"
    subnet_ids = [
      dependency.subnets.outputs.subnet_ids["tgw-eu-west-2a"],
      dependency.subnets.outputs.subnet_ids["tgw-eu-west-2b"],
      dependency.subnets.outputs.subnet_ids["tgw-eu-west-2c"],
    ]
    transit_gateway_default_route_table_association = true
    transit_gateway_default_route_table_propagation = true
    transit_gateway_id                              = dependency.transit_gateway.outputs.transit_gateway_id
    vpc_id                                          = dependency.vpc.outputs.vpc_id
    tags = {
      Name = "primary-eu-west-2"
    }
  }
}
