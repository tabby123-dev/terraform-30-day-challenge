# Deploying a Static Website on AWS S3 with Terraform

This project demonstrates how to deploy a static website on AWS using Terraform with a reusable module structure, environment separation, remote state support, and CloudFront distribution.

The goal of this project is to practice Infrastructure as Code (IaC) principles while building a production-style Terraform workflow.

---

# Architecture Overview

This project provisions:

- An AWS S3 bucket for static website hosting
- CloudFront distribution for HTTPS and global content delivery
- Terraform remote state support
- Reusable Terraform modules
- Environment-specific configurations

---

# Project Structure

```text
day25-static-website/
├── backend.tf
├── provider.tf
├── modules/
│   └── s3-static-website/
│       ├── main.tf
│       ├── outputs.tf
│       └── variables.tf
└── env/
    └── dev/
        ├── main.tf
        ├── output.tf
        ├── terraform.tfvars
        ├── variables.tf
        └── provider.tf
```

---

# Why Use Modules?

Instead of placing all Terraform resources in one file, this project uses modules to:

- Improve code organization
- Support reusability
- Follow DRY (Don't Repeat Yourself) principles
- Make it easier to create additional environments like:
  - staging
  - production
  - testing

The reusable infrastructure logic lives inside:

```text
modules/s3-static-website
```

Environment-specific values are defined inside:

```text
env/dev
```

---

# DRY Principle in Practice

The DRY principle means writing infrastructure code once and reusing it.

In this project:

- The module contains the reusable AWS infrastructure logic
- The `env/dev` folder only contains environment-specific configuration

This avoids duplicating infrastructure code across environments.

---

# Remote State Benefits

Terraform state can become risky when stored locally.

Using remote state helps by:

- Providing centralized state storage
- Supporting team collaboration
- Preventing accidental overwrites
- Enabling state locking
- Protecting infrastructure consistency

---

# Prerequisites

Before running this project, install:

- [Terraform](https://developer.hashicorp.com/terraform/downloads)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

---

# Configure AWS Credentials

Authenticate using the AWS CLI:

```bash
aws configure
```

Provide:

- AWS Access Key
- AWS Secret Access Key
- Default region
- Output format

---

# Terraform Variables

Example `terraform.tfvars`:

```hcl
bucket_name    = "my-static-website-bucket"
environment    = "dev"
aws_region     = "us-east-1"
index_document = "index.html"
error_document = "error.html"
```

---

# How to Run the Project

## 1. Clone the Repository

```bash
git clone https://github.com/YOUR_USERNAME/day25-static-website.git
```

---

## 2. Navigate to the Environment Folder

```bash
cd day25-static-website/env/dev
```

---

## 3. Initialize Terraform

```bash
terraform init
```

This downloads:
- providers
- modules
- dependencies

---

## 4. Validate the Configuration

```bash
terraform validate
```

---

## 5. Preview Infrastructure Changes

```bash
terraform plan
```

---

## 6. Deploy Infrastructure

```bash
terraform apply
```

Type:

```text
yes
```

when prompted.

---

# Destroy Infrastructure

To avoid AWS charges:

```bash
terraform destroy
```

---

# Outputs

After deployment, Terraform will output:

- S3 bucket details
- CloudFront distribution URL
- Website endpoint

Example:

```text
https://d123abcxyz.cloudfront.net
```

---

# What I Learned

This project helped me understand:

- Terraform module structure
- Infrastructure as Code best practices
- AWS S3 static website hosting
- CloudFront integration
- Terraform remote state
- DRY principles
- Environment separation

---

# Future Improvements

Possible enhancements:

- Add Route53 custom domain support
- Add ACM SSL certificates
- Create staging and production environments
- Add CI/CD with GitHub Actions
- Enable automated deployments

---

# Useful Terraform Commands

## Format Terraform Files

```bash
terraform fmt
```

## Show Current State

```bash
terraform state list
```

## View Outputs

```bash
terraform output
```

---

# Resources

- [Terraform Documentation](https://developer.hashicorp.com/terraform/docs)
- [AWS S3 Documentation](https://docs.aws.amazon.com/s3/)
- [AWS CloudFront Documentation](https://docs.aws.amazon.com/cloudfront/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

---

# Author
tabby123-dev-Tabitha Ndungu 
Built as part of the **30-Day Terraform Challenge**.
