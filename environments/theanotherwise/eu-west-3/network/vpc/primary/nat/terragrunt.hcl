include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}//modules/nat"
}

dependency "subnets" {
  config_path = "../subnets"

  mock_outputs = {
    subnet_ids = {
      mgmt                 = "subnet-mock-mgmt"
      "primary-eu-west-3a" = "subnet-mock-a"
      "primary-eu-west-3b" = "subnet-mock-b"
      "primary-eu-west-3c" = "subnet-mock-c"
    }
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "destroy"]
  mock_outputs_merge_strategy_with_state  = "deep_map_only"
}

inputs = {
  nats = {
    "primary-eu-west-3a" = {
      subnet_id = dependency.subnets.outputs.subnet_ids["primary-eu-west-3a"]
      name      = "primary-eu-west-3a-pub"
    }
    "primary-eu-west-3b" = {
      subnet_id = dependency.subnets.outputs.subnet_ids["primary-eu-west-3b"]
      name      = "primary-eu-west-3b-pub"
    }
    "primary-eu-west-3c" = {
      subnet_id = dependency.subnets.outputs.subnet_ids["primary-eu-west-3c"]
      name      = "primary-eu-west-3c-pub"
    }
  }
}
