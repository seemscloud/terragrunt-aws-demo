include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}//modules/route_table"
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    vpc_id = "vpc-mock"
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "destroy"]
  mock_outputs_merge_strategy_with_state  = "deep_map_only"
}

inputs = {
  route_tables = {
    public = {
      vpc_id = dependency.vpc.outputs.vpc_id
      tags = {
        Tier = "public"
      }
    }
    "private-eu-west-2a" = {
      vpc_id = dependency.vpc.outputs.vpc_id
      tags = {
        AvailabilityZone = "eu-west-2a"
        Tier             = "private"
      }
    }
    "private-eu-west-2b" = {
      vpc_id = dependency.vpc.outputs.vpc_id
      tags = {
        AvailabilityZone = "eu-west-2b"
        Tier             = "private"
      }
    }
    "private-eu-west-2c" = {
      vpc_id = dependency.vpc.outputs.vpc_id
      tags = {
        AvailabilityZone = "eu-west-2c"
        Tier             = "private"
      }
    }
    "lb-eu-west-2a" = {
      vpc_id = dependency.vpc.outputs.vpc_id
      tags = {
        AvailabilityZone = "eu-west-2a"
        Tier             = "lb"
      }
    }
    "lb-eu-west-2b" = {
      vpc_id = dependency.vpc.outputs.vpc_id
      tags = {
        AvailabilityZone = "eu-west-2b"
        Tier             = "lb"
      }
    }
    "lb-eu-west-2c" = {
      vpc_id = dependency.vpc.outputs.vpc_id
      tags = {
        AvailabilityZone = "eu-west-2c"
        Tier             = "lb"
      }
    }
    mgmt = {
      vpc_id = dependency.vpc.outputs.vpc_id
      tags = {
        Tier = "mgmt"
      }
    }
    tgw = {
      vpc_id = dependency.vpc.outputs.vpc_id
      tags = {
        Tier = "tgw"
      }
    }
  }
}
