locals {
  aws_region = "eu-west-2"

  azs = [
    "eu-west-2a",
    "eu-west-2b",
    "eu-west-2c",
  ]

  region_tags = {
    Region = "eu-west-2"
  }
}
