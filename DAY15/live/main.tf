provider "aws" {
  alias  = "primary"
  region = "us-east-1"
}

provider "aws" {
  alias  = "replica"
  region = "us-west-2"
}

module "multi_region_app" {
  source = "./../modules/multi-region-app"
  app_name = "oke"

  providers = {
    aws.primary = aws.primary
    aws.replica = aws.replica
  }
}