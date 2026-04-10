# Root module — calls the webserver-cluster module.

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket       = "terraform-running"
    key          = "day18/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
  }
}

provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      ManagedBy = "terraform"
      Day       = "Day 18"
    }
  }
}

module "webserver_cluster" {
  source = "../modules/services/webserver-cluster"

  cluster_name  = "cluster-day18"
  instance_type = "t2.micro"
  min_size      = 2
  max_size      = 4
  environment   = "dev"
  project_name  = "30-Day Terraform Challenge"
  team_name     = "Tabby-Cloud"
}