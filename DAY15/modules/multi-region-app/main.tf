# modules/multi-region-app/main.tf
# No provider blocks inside the module — providers are passed in by the caller

terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = "~> 5.0"
      configuration_aliases = [aws.primary, aws.replica]
    }
  }
}

resource "aws_s3_bucket" "primary" {
  provider = aws.primary
  bucket   = "${var.app_name}-primary"
}

resource "aws_s3_bucket" "replica" {
  provider = aws.replica
  bucket   = "${var.app_name}-replica"
}