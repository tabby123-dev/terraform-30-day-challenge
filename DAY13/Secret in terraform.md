# Managing Sensitive Data Securely in Terraform

## Leak Path 1 --- Hardcoded in `.tf` files

### Unsecure Pattern

``` hcl
resource "aws_db_instance" "example_rds" {
  username = "dbuser"
  password = "Changeme-or"  # Hardcoded secret
}
```

### Mitigation

``` hcl
resource "aws_db_instance" "example_rds" {
  username = "dbuser"
  password = var.db_password  # Use variable instead
}
```

------------------------------------------------------------------------

## Leak Path 2 --- Passed as a Variable with a Default Value

### Unsecure Pattern

``` hcl
resource "aws_db_instance" "example_rds" {
  username = "dbuser"
  password = "Changeme-or"  # Default value exposes secret
}
```

### Mitigation

``` hcl
variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}
```

------------------------------------------------------------------------

## Leak Path 3 --- Stored in Plaintext in State

Secrets may be stored in plaintext in `terraform.tfstate`.

### Mitigation

-   Use a remote backend (e.g., S3) with encryption and restricted
    access
-   Enable state locking
-   Never commit state files to version control

### Use AWS Secrets Manager

``` hcl
data "aws_secretsmanager_secret" "db_credentials" {
  name = "prod/db/credentials"
}

data "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = data.aws_secretsmanager_secret.db_credentials.id
}

locals {
  db_credentials = jsondecode(
    data.aws_secretsmanager_secret_version.db_credentials.secret_string
  )
}
```

### Reference Secrets in Resources

``` hcl
resource "aws_db_instance" "example" {
  username = local.db_credentials["username"]
  password = local.db_credentials["password"]
}
```

------------------------------------------------------------------------

## Mark Outputs and Variables as Sensitive

``` hcl
output "ami_id" {
  value     = data.aws_ami.amazon_linux.id
  sensitive = true
}
```

------------------------------------------------------------------------

## Protect the State File

-   Apply encryption
-   Use strict access controls
-   Enable audit logging
-   Implement rotation policies

``` hcl
backend "s3" {
  bucket       = "terraform-bucket"
  key          = "secret/terraform.tfstate"
  region       = "us-east-1"
  encrypt      = true
  use_lockfile = true
}
```

**Important:** Never commit your state file to GitHub or any version
control system.

------------------------------------------------------------------------

## Use Environment Variables for Provider Credentials

``` bash
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_DEFAULT_REGION="us-east-1"
```

### Using Named Profile

``` bash
export AWS_PROFILE="your-profile-name"
```

Use environment variables in CI/CD pipelines to securely manage secrets.

------------------------------------------------------------------------
#30DayTerraformChallenge #TerraformChallenge #Terraform #Security #DevOps #IaC #AWSUserGroupKenya #EveOps

