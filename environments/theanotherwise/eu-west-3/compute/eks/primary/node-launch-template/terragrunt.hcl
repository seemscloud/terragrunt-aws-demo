include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}//modules/launch_template"
}

inputs = {
  launch_templates = {
    "primary-eu-west-3-node" = {
      block_device_mappings = [
        {
          device_name = "/dev/xvda"
          ebs = {
            volume_size = 20
            volume_type = "gp3"
          }
        }
      ]
    }
  }
}
