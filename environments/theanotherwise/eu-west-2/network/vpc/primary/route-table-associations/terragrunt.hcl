include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}//modules/route_table_association"
}

dependency "subnets" {
  config_path = "../subnets"

  mock_outputs = {
    subnet_ids = {
      mgmt                 = "subnet-mock-mgmt"
      "primary-eu-west-2a" = "subnet-mock-public-a"
      "primary-eu-west-2b" = "subnet-mock-public-b"
      "primary-eu-west-2c" = "subnet-mock-public-c"
      "private-eu-west-2a" = "subnet-mock-private-a"
      "private-eu-west-2b" = "subnet-mock-private-b"
      "private-eu-west-2c" = "subnet-mock-private-c"
      "lb-eu-west-2a"      = "subnet-mock-lb-a"
      "lb-eu-west-2b"      = "subnet-mock-lb-b"
      "lb-eu-west-2c"      = "subnet-mock-lb-c"
      "tgw-eu-west-2a"     = "subnet-mock-tgw-a"
      "tgw-eu-west-2b"     = "subnet-mock-tgw-b"
      "tgw-eu-west-2c"     = "subnet-mock-tgw-c"
    }
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
      tgw                  = "rtb-mock-tgw"
    }
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "destroy"]
  mock_outputs_merge_strategy_with_state  = "deep_map_only"
}

inputs = {
  route_table_associations = {
    "public-eu-west-2a" = {
      subnet_id      = dependency.subnets.outputs.subnet_ids["primary-eu-west-2a"]
      route_table_id = dependency.route_tables.outputs.route_table_ids["public"]
    }
    "public-eu-west-2b" = {
      subnet_id      = dependency.subnets.outputs.subnet_ids["primary-eu-west-2b"]
      route_table_id = dependency.route_tables.outputs.route_table_ids["public"]
    }
    "public-eu-west-2c" = {
      subnet_id      = dependency.subnets.outputs.subnet_ids["primary-eu-west-2c"]
      route_table_id = dependency.route_tables.outputs.route_table_ids["public"]
    }
    "private-eu-west-2a" = {
      subnet_id      = dependency.subnets.outputs.subnet_ids["private-eu-west-2a"]
      route_table_id = dependency.route_tables.outputs.route_table_ids["private-eu-west-2a"]
    }
    "private-eu-west-2b" = {
      subnet_id      = dependency.subnets.outputs.subnet_ids["private-eu-west-2b"]
      route_table_id = dependency.route_tables.outputs.route_table_ids["private-eu-west-2b"]
    }
    "private-eu-west-2c" = {
      subnet_id      = dependency.subnets.outputs.subnet_ids["private-eu-west-2c"]
      route_table_id = dependency.route_tables.outputs.route_table_ids["private-eu-west-2c"]
    }
    "lb-eu-west-2a" = {
      subnet_id      = dependency.subnets.outputs.subnet_ids["lb-eu-west-2a"]
      route_table_id = dependency.route_tables.outputs.route_table_ids["lb-eu-west-2a"]
    }
    "lb-eu-west-2b" = {
      subnet_id      = dependency.subnets.outputs.subnet_ids["lb-eu-west-2b"]
      route_table_id = dependency.route_tables.outputs.route_table_ids["lb-eu-west-2b"]
    }
    "lb-eu-west-2c" = {
      subnet_id      = dependency.subnets.outputs.subnet_ids["lb-eu-west-2c"]
      route_table_id = dependency.route_tables.outputs.route_table_ids["lb-eu-west-2c"]
    }
    mgmt = {
      subnet_id      = dependency.subnets.outputs.subnet_ids["mgmt"]
      route_table_id = dependency.route_tables.outputs.route_table_ids["mgmt"]
    }
    "tgw-eu-west-2a" = {
      subnet_id      = dependency.subnets.outputs.subnet_ids["tgw-eu-west-2a"]
      route_table_id = dependency.route_tables.outputs.route_table_ids["tgw"]
    }
    "tgw-eu-west-2b" = {
      subnet_id      = dependency.subnets.outputs.subnet_ids["tgw-eu-west-2b"]
      route_table_id = dependency.route_tables.outputs.route_table_ids["tgw"]
    }
    "tgw-eu-west-2c" = {
      subnet_id      = dependency.subnets.outputs.subnet_ids["tgw-eu-west-2c"]
      route_table_id = dependency.route_tables.outputs.route_table_ids["tgw"]
    }
  }
}
