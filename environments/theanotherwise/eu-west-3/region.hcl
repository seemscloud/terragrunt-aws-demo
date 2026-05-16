locals {
  aws_region = "eu-west-3"

  azs = [
    "eu-west-3a",
    "eu-west-3b",
    "eu-west-3c",
  ]

  region_tags = {
    Region = "eu-west-3"
  }
}
