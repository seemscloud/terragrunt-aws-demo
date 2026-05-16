include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}//modules/eks_addon"
}

dependency "cluster" {
  config_path = "../../cluster"

  mock_outputs = {
    cluster_name = "primary"
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "destroy"]
  mock_outputs_merge_strategy_with_state  = "deep_map_only"
}

locals {
  remote_lb_cidr_blocks = ["10.1.20.0/24", "10.1.21.0/24", "10.1.22.0/24", "10.3.20.0/24", "10.3.21.0/24", "10.3.22.0/24"]
}

inputs = {
  eks_addons = {
    "vpc-cni" = {
      cluster_name = dependency.cluster.outputs.cluster_name
      addon_name   = "vpc-cni"
      configuration_values = jsonencode({
        env = {
          AWS_VPC_K8S_CNI_EXCLUDE_SNAT_CIDRS = join(",", local.remote_lb_cidr_blocks)
        }
      })
    }
  }
}
