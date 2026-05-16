include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}//modules/subnet"
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    vpc_id              = "vpc-mock"
    vpc_cidr_block      = "10.3.0.0/16"
    internet_gateway_id = "igw-mock"
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "destroy"]
  mock_outputs_merge_strategy_with_state  = "deep_map_only"
}

inputs = {
  vpc_id = dependency.vpc.outputs.vpc_id

  subnets = {
    mgmt = {
      cidr_block              = "10.3.255.240/28"
      availability_zone       = "eu-west-3a"
      map_public_ip_on_launch = true
      tags = {
        Tier = "mgmt"
      }
    }
    "primary-eu-west-3a" = {
      cidr_block              = "10.3.0.0/24"
      availability_zone       = "eu-west-3a"
      map_public_ip_on_launch = true
      name                    = "primary-eu-west-3a-pub"
      tags = {
        Tier                            = "public"
        "kubernetes.io/cluster/primary" = "shared"
        "kubernetes.io/role/elb"        = "1"
      }
    }
    "primary-eu-west-3b" = {
      cidr_block              = "10.3.1.0/24"
      availability_zone       = "eu-west-3b"
      map_public_ip_on_launch = true
      name                    = "primary-eu-west-3b-pub"
      tags = {
        Tier                            = "public"
        "kubernetes.io/cluster/primary" = "shared"
        "kubernetes.io/role/elb"        = "1"
      }
    }
    "primary-eu-west-3c" = {
      cidr_block              = "10.3.2.0/24"
      availability_zone       = "eu-west-3c"
      map_public_ip_on_launch = true
      name                    = "primary-eu-west-3c-pub"
      tags = {
        Tier                            = "public"
        "kubernetes.io/cluster/primary" = "shared"
        "kubernetes.io/role/elb"        = "1"
      }
    }
    "private-eu-west-3a" = {
      cidr_block              = "10.3.10.0/24"
      availability_zone       = "eu-west-3a"
      map_public_ip_on_launch = false
      name                    = "primary-eu-west-3a-prv"
      tags = {
        Tier                            = "private"
        "kubernetes.io/cluster/primary" = "shared"
      }
    }
    "private-eu-west-3b" = {
      cidr_block              = "10.3.11.0/24"
      availability_zone       = "eu-west-3b"
      map_public_ip_on_launch = false
      name                    = "primary-eu-west-3b-prv"
      tags = {
        Tier                            = "private"
        "kubernetes.io/cluster/primary" = "shared"
      }
    }
    "private-eu-west-3c" = {
      cidr_block              = "10.3.12.0/24"
      availability_zone       = "eu-west-3c"
      map_public_ip_on_launch = false
      name                    = "primary-eu-west-3c-prv"
      tags = {
        Tier                            = "private"
        "kubernetes.io/cluster/primary" = "shared"
      }
    }
    "lb-eu-west-3a" = {
      cidr_block              = "10.3.20.0/24"
      availability_zone       = "eu-west-3a"
      map_public_ip_on_launch = false
      name                    = "primary-eu-west-3a-lb"
      tags = {
        Tier                              = "lb"
        "kubernetes.io/cluster/primary"   = "shared"
        "kubernetes.io/role/internal-elb" = "1"
      }
    }
    "lb-eu-west-3b" = {
      cidr_block              = "10.3.21.0/24"
      availability_zone       = "eu-west-3b"
      map_public_ip_on_launch = false
      name                    = "primary-eu-west-3b-lb"
      tags = {
        Tier                              = "lb"
        "kubernetes.io/cluster/primary"   = "shared"
        "kubernetes.io/role/internal-elb" = "1"
      }
    }
    "lb-eu-west-3c" = {
      cidr_block              = "10.3.22.0/24"
      availability_zone       = "eu-west-3c"
      map_public_ip_on_launch = false
      name                    = "primary-eu-west-3c-lb"
      tags = {
        Tier                              = "lb"
        "kubernetes.io/cluster/primary"   = "shared"
        "kubernetes.io/role/internal-elb" = "1"
      }
    }
    "tgw-eu-west-3a" = {
      cidr_block              = "10.3.30.0/28"
      availability_zone       = "eu-west-3a"
      map_public_ip_on_launch = false
      name                    = "primary-eu-west-3a-tgw"
      tags = {
        Tier = "tgw"
      }
    }
    "tgw-eu-west-3b" = {
      cidr_block              = "10.3.30.16/28"
      availability_zone       = "eu-west-3b"
      map_public_ip_on_launch = false
      name                    = "primary-eu-west-3b-tgw"
      tags = {
        Tier = "tgw"
      }
    }
    "tgw-eu-west-3c" = {
      cidr_block              = "10.3.30.32/28"
      availability_zone       = "eu-west-3c"
      map_public_ip_on_launch = false
      name                    = "primary-eu-west-3c-tgw"
      tags = {
        Tier = "tgw"
      }
    }
  }
}
