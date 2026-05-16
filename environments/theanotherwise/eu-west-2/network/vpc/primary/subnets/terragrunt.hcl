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
    vpc_cidr_block      = "10.2.0.0/16"
    internet_gateway_id = "igw-mock"
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "destroy"]
  mock_outputs_merge_strategy_with_state  = "deep_map_only"
}

inputs = {
  vpc_id = dependency.vpc.outputs.vpc_id

  subnets = {
    mgmt = {
      cidr_block              = "10.2.255.240/28"
      availability_zone       = "eu-west-2a"
      map_public_ip_on_launch = true
      tags = {
        Tier = "mgmt"
      }
    }
    "primary-eu-west-2a" = {
      cidr_block              = "10.2.0.0/24"
      availability_zone       = "eu-west-2a"
      map_public_ip_on_launch = true
      name                    = "primary-eu-west-2a-pub"
      tags = {
        Tier                            = "public"
        "kubernetes.io/cluster/primary" = "shared"
        "kubernetes.io/role/elb"        = "1"
      }
    }
    "primary-eu-west-2b" = {
      cidr_block              = "10.2.1.0/24"
      availability_zone       = "eu-west-2b"
      map_public_ip_on_launch = true
      name                    = "primary-eu-west-2b-pub"
      tags = {
        Tier                            = "public"
        "kubernetes.io/cluster/primary" = "shared"
        "kubernetes.io/role/elb"        = "1"
      }
    }
    "primary-eu-west-2c" = {
      cidr_block              = "10.2.2.0/24"
      availability_zone       = "eu-west-2c"
      map_public_ip_on_launch = true
      name                    = "primary-eu-west-2c-pub"
      tags = {
        Tier                            = "public"
        "kubernetes.io/cluster/primary" = "shared"
        "kubernetes.io/role/elb"        = "1"
      }
    }
    "private-eu-west-2a" = {
      cidr_block              = "10.2.10.0/24"
      availability_zone       = "eu-west-2a"
      map_public_ip_on_launch = false
      name                    = "primary-eu-west-2a-prv"
      tags = {
        Tier                            = "private"
        "kubernetes.io/cluster/primary" = "shared"
      }
    }
    "private-eu-west-2b" = {
      cidr_block              = "10.2.11.0/24"
      availability_zone       = "eu-west-2b"
      map_public_ip_on_launch = false
      name                    = "primary-eu-west-2b-prv"
      tags = {
        Tier                            = "private"
        "kubernetes.io/cluster/primary" = "shared"
      }
    }
    "private-eu-west-2c" = {
      cidr_block              = "10.2.12.0/24"
      availability_zone       = "eu-west-2c"
      map_public_ip_on_launch = false
      name                    = "primary-eu-west-2c-prv"
      tags = {
        Tier                            = "private"
        "kubernetes.io/cluster/primary" = "shared"
      }
    }
    "lb-eu-west-2a" = {
      cidr_block              = "10.2.20.0/24"
      availability_zone       = "eu-west-2a"
      map_public_ip_on_launch = false
      name                    = "primary-eu-west-2a-lb"
      tags = {
        Tier                              = "lb"
        "kubernetes.io/cluster/primary"   = "shared"
        "kubernetes.io/role/internal-elb" = "1"
      }
    }
    "lb-eu-west-2b" = {
      cidr_block              = "10.2.21.0/24"
      availability_zone       = "eu-west-2b"
      map_public_ip_on_launch = false
      name                    = "primary-eu-west-2b-lb"
      tags = {
        Tier                              = "lb"
        "kubernetes.io/cluster/primary"   = "shared"
        "kubernetes.io/role/internal-elb" = "1"
      }
    }
    "lb-eu-west-2c" = {
      cidr_block              = "10.2.22.0/24"
      availability_zone       = "eu-west-2c"
      map_public_ip_on_launch = false
      name                    = "primary-eu-west-2c-lb"
      tags = {
        Tier                              = "lb"
        "kubernetes.io/cluster/primary"   = "shared"
        "kubernetes.io/role/internal-elb" = "1"
      }
    }
    "tgw-eu-west-2a" = {
      cidr_block              = "10.2.30.0/28"
      availability_zone       = "eu-west-2a"
      map_public_ip_on_launch = false
      name                    = "primary-eu-west-2a-tgw"
      tags = {
        Tier = "tgw"
      }
    }
    "tgw-eu-west-2b" = {
      cidr_block              = "10.2.30.16/28"
      availability_zone       = "eu-west-2b"
      map_public_ip_on_launch = false
      name                    = "primary-eu-west-2b-tgw"
      tags = {
        Tier = "tgw"
      }
    }
    "tgw-eu-west-2c" = {
      cidr_block              = "10.2.30.32/28"
      availability_zone       = "eu-west-2c"
      map_public_ip_on_launch = false
      name                    = "primary-eu-west-2c-tgw"
      tags = {
        Tier = "tgw"
      }
    }
  }
}
