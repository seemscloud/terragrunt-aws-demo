include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}//modules/route"
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    internet_gateway_id = "igw-mock"
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "destroy"]
  mock_outputs_merge_strategy_with_state  = "deep_map_only"
}

dependency "route_tables" {
  config_path = "../route-tables"

  mock_outputs = {
    route_table_ids = {
      public               = "rtb-mock-public"
      "private-eu-west-1a" = "rtb-mock-private-a"
      "private-eu-west-1b" = "rtb-mock-private-b"
      "private-eu-west-1c" = "rtb-mock-private-c"
      mgmt                 = "rtb-mock-mgmt"
    }
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "destroy"]
  mock_outputs_merge_strategy_with_state  = "deep_map_only"
}

dependency "nat" {
  config_path = "../nat"

  mock_outputs = {
    nat_gateway_ids = {
      "primary-eu-west-1a" = "nat-mock-a"
      "primary-eu-west-1b" = "nat-mock-b"
      "primary-eu-west-1c" = "nat-mock-c"
    }
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "destroy"]
  mock_outputs_merge_strategy_with_state  = "deep_map_only"
}

dependency "vpc_peering_from_eu_central_1" {
  config_path = "../peering-from-eu-central-1"

  mock_outputs = {
    vpc_peering_connection_id = "pcx-0123456789abcdef0"
    accept_status             = "active"
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "destroy"]
  mock_outputs_merge_strategy_with_state  = "deep_map_only"
}

inputs = {
  routes = merge(
    {
      "public-default-igw" = {
        route_table_id         = dependency.route_tables.outputs.route_table_ids["public"]
        destination_cidr_block = "0.0.0.0/0"
        gateway_id             = dependency.vpc.outputs.internet_gateway_id
      }
      "private-eu-west-1a-default-nat" = {
        route_table_id         = dependency.route_tables.outputs.route_table_ids["private-eu-west-1a"]
        destination_cidr_block = "0.0.0.0/0"
        nat_gateway_id         = dependency.nat.outputs.nat_gateway_ids["primary-eu-west-1a"]
      }
      "private-eu-west-1b-default-nat" = {
        route_table_id         = dependency.route_tables.outputs.route_table_ids["private-eu-west-1b"]
        destination_cidr_block = "0.0.0.0/0"
        nat_gateway_id         = dependency.nat.outputs.nat_gateway_ids["primary-eu-west-1b"]
      }
      "private-eu-west-1c-default-nat" = {
        route_table_id         = dependency.route_tables.outputs.route_table_ids["private-eu-west-1c"]
        destination_cidr_block = "0.0.0.0/0"
        nat_gateway_id         = dependency.nat.outputs.nat_gateway_ids["primary-eu-west-1c"]
      }
      "mgmt-default-igw" = {
        route_table_id         = dependency.route_tables.outputs.route_table_ids["mgmt"]
        destination_cidr_block = "0.0.0.0/0"
        gateway_id             = dependency.vpc.outputs.internet_gateway_id
      }
    },
    {
      for route in setproduct(
        ["private-eu-west-1a", "private-eu-west-1b", "private-eu-west-1c"],
        ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24", "10.0.20.0/24", "10.0.21.0/24", "10.0.22.0/24"]
        ) : "${route[0]}-eu-central-1-${replace(replace(route[1], ".", "-"), "/", "-")}" => {
        route_table_id            = dependency.route_tables.outputs.route_table_ids[route[0]]
        destination_cidr_block    = route[1]
        vpc_peering_connection_id = dependency.vpc_peering_from_eu_central_1.outputs.vpc_peering_connection_id
      }
    }
  )
}
