# Provider Deep Dive

## Multiple AWS Regions, Provider Aliases, Version Pinning, and Lock File

------------------------------------------------------------------------

## Provider Configuration

Configuring two region providers and using data sources to query both
regions:

``` hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
  alias  = "region1" # Alias for region1
}

provider "aws" {
  region = "us-west-1"
  alias  = "region2" # Alias for region2
}

data "aws_region" "region1" {
  provider = aws.region1
}

data "aws_region" "region2" {
  provider = aws.region2
}
```

------------------------------------------------------------------------

## Multi-Region Deployment Code

Allows deployment to multiple regions:

``` hcl
data "aws_ami" "ubuntu_region1" {
  provider    = aws.region1
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}
```

**Key Note:**\
`provider = aws.region1` tells Terraform which provider (region/account)
to use.

------------------------------------------------------------------------

## .terraform.lock.hcl Explanation

Terraform automatically creates or updates this file during
`terraform init`.

-   Locks provider versions
-   Ensures reproducibility
-   Should be committed to version control

------------------------------------------------------------------------

## Multi-Account Setup

### 1. IAM Role in Target Account

``` json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::<SOURCE_ACCOUNT_ID>:root"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
```

------------------------------------------------------------------------

### 2. Configure Providers with Assume Role

``` hcl
provider "aws" {
  region = "us-east-2"
  alias  = "region1"

  assume_role {
    role_arn = "arn:aws:iam::111111111111:role/TerraformDeployRole"
  }
}

provider "aws" {
  region = "us-west-1"
  alias  = "region2"

  assume_role {
    role_arn = "arn:aws:iam::222222222222:role/TerraformDeployRole"
  }
}
```

------------------------------------------------------------------------

### 3. Deploy Resources

Reuse the same pattern. Terraform uses base credentials to assume roles.

------------------------------------------------------------------------

## Chapter 7 Learnings (Terraform Up & Running)

### 1. What happens during `terraform init`?

-   Reads `required_providers`
-   Resolves versions
-   Downloads providers
-   Stores them in `.terraform`
-   Creates `.terraform.lock.hcl`
-   Verifies existing providers if already installed

------------------------------------------------------------------------

### 2. Version vs `~>` Constraint

-   `version = "4.0.0"` → exact version only
-   `version = "~> 4.0"` → allows versions `>=4.0.0` and `<5.0.0`

------------------------------------------------------------------------

### 3. Why every resource needs one provider

Each resource maps to an external API.

Terraform needs: - Credentials - Region - Execution context

If no provider is specified: - Terraform infers from resource type
(`aws_instance` → `aws`) - Uses default provider (non-aliased) - Errors
if only aliased providers exist
----
#30DayTerraformChallenge #TerraformChallenge #Terraform #AWS #MultiRegion #IaC #AWSUserGroupKenya #EveOps
