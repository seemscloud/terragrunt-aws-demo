include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}//modules/route53_record"
}

dependency "private_zone" {
  config_path = "../private-zone"

  mock_outputs = {
    zone_id = "Z00000000000000000000"
    name    = "aws.seems.cloud"
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "destroy"]
  mock_outputs_merge_strategy_with_state  = "deep_map_only"
}

dependency "eu_central_1_service" {
  config_path = "../../../../eu-central-1/compute/eks-primary/workloads/nginx/service"

  mock_outputs = {
    load_balancer_hostnames = {
      nginx = "internal-nginx-eu-central-1.elb.amazonaws.com"
    }
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "destroy"]
  mock_outputs_merge_strategy_with_state  = "deep_map_only"
}

dependency "eu_west_1_service" {
  config_path = "../../../../eu-west-1/compute/eks-primary/workloads/nginx/service"

  mock_outputs = {
    load_balancer_hostnames = {
      nginx = "internal-nginx-eu-west-1.elb.amazonaws.com"
    }
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "destroy"]
  mock_outputs_merge_strategy_with_state  = "deep_map_only"
}

inputs = {
  route53_records = {
    "nginx-default-eu-central-1" = {
      zone_id = dependency.private_zone.outputs.zone_id
      name    = "nginx.default.eks-primary.eks.eu-central-1.aws.seems.cloud"
      type    = "CNAME"
      ttl     = 60
      records = [dependency.eu_central_1_service.outputs.load_balancer_hostnames["nginx"]]
    }
    "nginx-default-eu-west-1" = {
      zone_id = dependency.private_zone.outputs.zone_id
      name    = "nginx.default.eks-primary.eks.eu-west-1.aws.seems.cloud"
      type    = "CNAME"
      ttl     = 60
      records = [dependency.eu_west_1_service.outputs.load_balancer_hostnames["nginx"]]
    }
  }
}
