/*
provider "aws" {
    region = var.region
    profile = var.profile
  
}
resource "aws_s3_bucket" "terraform_state" {
    bucket = var.bucket
    #prevent accidental deletion
    lifecycle {
      prevent_destroy = false
    }
}
# Enable versioning so you can see the full revision history of your
resource "aws_s3_bucket_versioning" "enabled" {
    bucket = aws_s3_bucket.terraform_state.id
    versioning_configuration {
      status = "Enabled"
    }
}
# Enable server-side encryption by default
resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
    bucket = aws_s3_bucket.terraform_state.id
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  
}
#Explicitlty block public access on the S3 Bucket.
resource "aws_s3_bucket_public_access_block" "public_access" {
    bucket = aws_s3_bucket.terraform_state.id
    block_public_acls = true
    block_public_policy = true
    ignore_public_acls = true
    restrict_public_buckets = true
  
}

#Dynamo db with tf to store sste file
resource "aws_dynamodb_table" "terraform_locks" {
    name = var.dynamodb_table
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "LockID"
    attribute {
      name = "LockID"
      type = "S"
    }
  
}
*/