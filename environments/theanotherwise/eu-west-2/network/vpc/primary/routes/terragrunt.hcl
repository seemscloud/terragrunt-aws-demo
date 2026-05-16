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
      "private-eu-west-2a" = "rtb-mock-private-a"
      "private-eu-west-2b" = "rtb-mock-private-b"
      "private-eu-west-2c" = "rtb-mock-private-c"
      "lb-eu-west-2a"      = "rtb-mock-lb-a"
      "lb-eu-west-2b"      = "rtb-mock-lb-b"
      "lb-eu-west-2c"      = "rtb-mock-lb-c"
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
      "primary-eu-west-2a" = "nat-mock-a"
      "primary-eu-west-2b" = "nat-mock-b"
      "primary-eu-west-2c" = "nat-mock-c"
    }
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "destroy"]
  mock_outputs_merge_strategy_with_state  = "deep_map_only"
}

dependency "transit_gateway" {
  config_path = "../../../transit-gateway/gateway"

  mock_outputs = {
    transit_gateway_id = "tgw-0123456789abcdef0"
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "destroy"]
  mock_outputs_merge_strategy_with_state  = "deep_map_only"
}

dependencies {
  paths = ["../../../transit-gateway/vpc-attachment/primary"]
}

locals {
  private_route_table_keys = ["private-eu-west-2a", "private-eu-west-2b", "private-eu-west-2c"]
  lb_route_table_keys      = ["lb-eu-west-2a", "lb-eu-west-2b", "lb-eu-west-2c"]
  remote_lb_subnets        = ["10.1.20.0/24", "10.1.21.0/24", "10.1.22.0/24", "10.3.20.0/24", "10.3.21.0/24", "10.3.22.0/24"]
  remote_private_subnets   = ["10.1.10.0/24", "10.1.11.0/24", "10.1.12.0/24", "10.3.10.0/24", "10.3.11.0/24", "10.3.12.0/24"]
}

inputs = {
  routes = merge(
    {
      "public-default-igw" = {
        route_table_id         = dependency.route_tables.outputs.route_table_ids["public"]
        destination_cidr_block = "0.0.0.0/0"
        gateway_id             = dependency.vpc.outputs.internet_gateway_id
      }
      "private-eu-west-2a-default-nat" = {
        route_table_id         = dependency.route_tables.outputs.route_table_ids["private-eu-west-2a"]
        destination_cidr_block = "0.0.0.0/0"
        nat_gateway_id         = dependency.nat.outputs.nat_gateway_ids["primary-eu-west-2a"]
      }
      "private-eu-west-2b-default-nat" = {
        route_table_id         = dependency.route_tables.outputs.route_table_ids["private-eu-west-2b"]
        destination_cidr_block = "0.0.0.0/0"
        nat_gateway_id         = dependency.nat.outputs.nat_gateway_ids["primary-eu-west-2b"]
      }
      "private-eu-west-2c-default-nat" = {
        route_table_id         = dependency.route_tables.outputs.route_table_ids["private-eu-west-2c"]
        destination_cidr_block = "0.0.0.0/0"
        nat_gateway_id         = dependency.nat.outputs.nat_gateway_ids["primary-eu-west-2c"]
      }
      "mgmt-default-igw" = {
        route_table_id         = dependency.route_tables.outputs.route_table_ids["mgmt"]
        destination_cidr_block = "0.0.0.0/0"
        gateway_id             = dependency.vpc.outputs.internet_gateway_id
      }
    },
    {
      for route in setproduct(local.private_route_table_keys, concat(local.remote_lb_subnets, local.remote_private_subnets)) : "${route[0]}-${replace(replace(route[1], ".", "-"), "/", "-")}" => {
        route_table_id         = dependency.route_tables.outputs.route_table_ids[route[0]]
        destination_cidr_block = route[1]
        transit_gateway_id     = dependency.transit_gateway.outputs.transit_gateway_id
      }
    },
    {
      for route in setproduct(local.lb_route_table_keys, local.remote_private_subnets) : "${route[0]}-${replace(replace(route[1], ".", "-"), "/", "-")}" => {
        route_table_id         = dependency.route_tables.outputs.route_table_ids[route[0]]
        destination_cidr_block = route[1]
        transit_gateway_id     = dependency.transit_gateway.outputs.transit_gateway_id
      }
    }
  )
}
