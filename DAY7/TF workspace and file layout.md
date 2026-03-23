# Day 7: Terraform Workspaces and File Layouts

On Day 7 of my 30-day Terraform challenge, I explored how to use Terraform workspaces and file layouts for state isolation. This guide covers:

* Creating and switching workspaces
* Using workspaces in Terraform configuration
* Connecting Terraform state to a remote backend
* Structuring multi-environment Terraform projects

---

## When to Use Terraform Workspaces

Terraform workspaces are used when you want to manage multiple environments using the **same Terraform configuration** while keeping their state files separate. This is ideal for:

* Multi-environment projects (dev, staging, prod)
* Production use cases where isolated states are needed

---

## Creating a Workspace

```bash
terraform workspace new dev
terraform workspace new staging
terraform workspace new prod
```

### Listing Workspaces

```bash
terraform workspace list
```

### Switching to a Workspace

```bash
terraform workspace select prod
```

---

## Using Workspace in Terraform Configuration

You can parameterize resources based on the workspace:

```hcl
variable "instance_type" {
  description = "EC2 instance type per environment"
  type        = map(string)
  default = {
    "dev"       = "t2.micro"
    "staging"   = "t2.small"
    "production" = "t2.medium"
  }
}

resource "aws_instance" "web" {
    ami = "ami-02dfbd4ff395f2a1b"
    instance_type = var.instance_type[terraform.workspace]
    tags = {
      name = "web-${terraform.workspace}"
      environment = terraform.workspace
    }
  
}

#backend.tf
terraform {
  backend "s3" {
    bucket         = "your bucket name"
    key            = "terraform.tfstate"
    region         = "us-east-1"
   
    encrypt        = true
  }
}
```
After running terraform plan and terraform apply, the state files are stored in your bucket, with each environment maintaining its own separate state file.
<img width="545" height="323" alt="image" src="https://github.com/user-attachments/assets/25f46983-6879-4605-b119-389b5bb95df2" />
File layout structure
```
$ tree
|-- environment
|   |-- dev
|   |   |-- backend.tf
|   |   |-- main.tf
|   |   |-- output.tf
|   |   `-- variables.tf
|   |-- prod
|   |   |-- backend.tf
|   |   |-- main.tf
|   |   |-- output.tf
|   |   `-- variables.tf
|   `-- staging
|       |-- backend.tf
|       |-- main.tf
|       |-- output.tf
|       `-- variables.tf
```
Remote Statefile config in the tf config
```
# environments/dev/backend.tf
terraform {
  backend "s3" {
    bucket         = "your bucket name"
    key            = "env/staging/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}
```
