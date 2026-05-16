include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}//modules/security_group_rule"
}

dependency "cluster" {
  config_path = "../cluster"

  mock_outputs = {
    cluster_security_group_id = "sg-0123456789abcdef0"
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "destroy"]
  mock_outputs_merge_strategy_with_state  = "deep_map_only"
}

dependency "mgmt_security_group" {
  config_path = "../../../mgmt/security-group"

  mock_outputs = {
    security_group_ids = {
      mgmt = "sg-0123456789abcdef1"
    }
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "destroy"]
  mock_outputs_merge_strategy_with_state  = "deep_map_only"
}

inputs = {
  security_group_rules = {
    "mgmt-to-nodes" = {
      type                     = "ingress"
      security_group_id        = dependency.cluster.outputs.cluster_security_group_id
      description              = "mgmt"
      from_port                = 0
      to_port                  = 0
      protocol                 = "-1"
      source_security_group_id = dependency.mgmt_security_group.outputs.security_group_ids["mgmt"]
    }
  }
}
