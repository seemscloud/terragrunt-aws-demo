include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}//modules/kubernetes_deployment"
}

dependency "cluster" {
  config_path = "../../../cluster"

  mock_outputs = {
    cluster_name                       = "primary-eu-central-1"
    cluster_endpoint                   = "https://mock.eks.local"
    cluster_certificate_authority_data = "dGVzdA=="
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "destroy"]
  mock_outputs_merge_strategy_with_state  = "deep_map_only"
}

dependencies {
  paths = ["../../../node-groups"]
}

generate "kubernetes_provider" {
  path      = "kubernetes-provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
data "aws_eks_cluster_auth" "this" {
  name = "${dependency.cluster.outputs.cluster_name}"
}

provider "kubernetes" {
  host                   = "${dependency.cluster.outputs.cluster_endpoint}"
  cluster_ca_certificate = base64decode("${dependency.cluster.outputs.cluster_certificate_authority_data}")
  token                  = data.aws_eks_cluster_auth.this.token
}
EOF
}

inputs = {
  deployments = {
    nginx = {
      namespace = "default"
      replicas  = 1
      container = {
        name  = "nginx"
        image = "nginx:alpine"
        port  = 80
      }
    }
  }
}
