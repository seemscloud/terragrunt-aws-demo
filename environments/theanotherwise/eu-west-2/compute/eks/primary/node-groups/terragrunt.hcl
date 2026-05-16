include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}//modules/eks_node_group"
}

dependency "cluster" {
  config_path = "../cluster"

  mock_outputs = {
    cluster_name = "primary"
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "destroy"]
  mock_outputs_merge_strategy_with_state  = "deep_map_only"
}

dependency "node_role" {
  config_path = "../node-role"

  mock_outputs = {
    role_arn  = "arn:aws:iam::674403012652:role/primary-eu-west-2-node"
    role_name = "primary-eu-west-2-node"
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "destroy"]
  mock_outputs_merge_strategy_with_state  = "deep_map_only"
}

dependency "subnets" {
  config_path = "../../../../network/vpc/primary/subnets"

  mock_outputs = {
    subnet_ids = {
      "private-eu-west-2a" = "subnet-mock-private-a"
      "private-eu-west-2b" = "subnet-mock-private-b"
      "private-eu-west-2c" = "subnet-mock-private-c"
    }
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "destroy"]
  mock_outputs_merge_strategy_with_state  = "deep_map_only"
}

dependency "node_launch_template" {
  config_path = "../node-launch-template"

  mock_outputs = {
    launch_template_ids = {
      "primary-eu-west-2-node" = "lt-0123456789abcdef0"
    }
    launch_template_latest_versions = {
      "primary-eu-west-2-node" = "1"
    }
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "destroy"]
  mock_outputs_merge_strategy_with_state  = "deep_map_only"
}

dependencies {
  paths = [
    "../addons/vpc-cni",
    "../node-role-policy-attachments",
    "../../../../network/vpc/primary/route-table-associations",
    "../../../../network/vpc/primary/routes",
  ]
}

inputs = {
  eks_node_groups = {
    "primary-eu-west-2a" = {
      cluster_name   = dependency.cluster.outputs.cluster_name
      node_role_arn  = dependency.node_role.outputs.role_arn
      subnet_ids     = [dependency.subnets.outputs.subnet_ids["private-eu-west-2a"]]
      desired_size   = 1
      max_size       = 1
      min_size       = 1
      ami_type       = "AL2023_x86_64_STANDARD"
      capacity_type  = "SPOT"
      instance_types = ["m7i.xlarge", "m6i.xlarge", "m6a.xlarge"]
      launch_template = {
        id      = dependency.node_launch_template.outputs.launch_template_ids["primary-eu-west-2-node"]
        version = dependency.node_launch_template.outputs.launch_template_latest_versions["primary-eu-west-2-node"]
      }
      tags = {
        AvailabilityZone = "eu-west-2a"
      }
    }
    "primary-eu-west-2b" = {
      cluster_name   = dependency.cluster.outputs.cluster_name
      node_role_arn  = dependency.node_role.outputs.role_arn
      subnet_ids     = [dependency.subnets.outputs.subnet_ids["private-eu-west-2b"]]
      desired_size   = 1
      max_size       = 1
      min_size       = 1
      ami_type       = "AL2023_x86_64_STANDARD"
      capacity_type  = "SPOT"
      instance_types = ["m7i.xlarge", "m6i.xlarge", "m6a.xlarge"]
      launch_template = {
        id      = dependency.node_launch_template.outputs.launch_template_ids["primary-eu-west-2-node"]
        version = dependency.node_launch_template.outputs.launch_template_latest_versions["primary-eu-west-2-node"]
      }
      tags = {
        AvailabilityZone = "eu-west-2b"
      }
    }
    "primary-eu-west-2c" = {
      cluster_name   = dependency.cluster.outputs.cluster_name
      node_role_arn  = dependency.node_role.outputs.role_arn
      subnet_ids     = [dependency.subnets.outputs.subnet_ids["private-eu-west-2c"]]
      desired_size   = 1
      max_size       = 1
      min_size       = 1
      ami_type       = "AL2023_x86_64_STANDARD"
      capacity_type  = "SPOT"
      instance_types = ["m7i.xlarge", "m6i.xlarge", "m6a.xlarge"]
      launch_template = {
        id      = dependency.node_launch_template.outputs.launch_template_ids["primary-eu-west-2-node"]
        version = dependency.node_launch_template.outputs.launch_template_latest_versions["primary-eu-west-2-node"]
      }
      tags = {
        AvailabilityZone = "eu-west-2c"
      }
    }
  }
}
