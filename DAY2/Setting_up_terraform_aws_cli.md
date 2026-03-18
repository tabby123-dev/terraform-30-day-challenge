# Setup Instructions: Terraform, AWS CLI, and AWS Environment

This guide provides step-by-step instructions to set up Terraform, the AWS CLI, and configure your AWS environment.

---

##  1. Prerequisites

Before you begin, ensure you have:

- An active **AWS account**
- A **virtual machine** or local system running:
  - Ubuntu / Windows / or your preferred OS

---

##  2. Install AWS CLI

Follow the steps below to install AWS CLI (Linux example):

```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update
```

---

##  3. Verify AWS CLI Installation

```bash
aws --version
```

---

##  4. Configure AWS CLI

>  **Note:** It is not recommended to use the root AWS account. Create an IAM user (e.g., `terraform-user`) with appropriate permissions.

### Configure credentials:

```bash
aws configure --profile terraform-user
```

Enter the following details when prompted:

```
AWS Access Key ID: <your-access-key>
AWS Secret Access Key: <your-secret-key>
Default region name: us-east-1
Default output format: json
```

### Test AWS connectivity:

```bash
aws configure list-profiles
aws sts get-caller-identity --profile terraform-user
```
Additional inacase you face issues in windows.
```bash
export PATH=$PATH:"/c/Program Files/Amazon/AWSCLIV2/"
export AWS_PROFILE="terraform-user"

```
---

##  5. Install Terraform

Download Terraform from the official HashiCorp releases page:

```bash
wget https://releases.hashicorp.com/terraform/1.7.5/terraform_1.7.5_linux_amd64.zip
```

### Unzip and move binary:

```bash
unzip terraform_1.7.5_linux_amd64.zip
sudo mv terraform /usr/local/bin/
```

---

##  6. Verify Terraform Installation

```bash
terraform --version
```

---

##  You're Ready!

Your environment is now fully set up. You can start writing and deploying your first Terraform project.

---
