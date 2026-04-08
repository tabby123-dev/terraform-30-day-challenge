# Terraform AWS Infrastructure Project

This project provisions AWS infrastructure using Terraform with a modular structure. It includes reusable modules for:

- Application Load Balancer (`alb`)
- Auto Scaling Group (`asg`)
- Launch Template (`launch-template`)

---

## 📁 Project Structure

```
.
├── main.tf
├── provider.tf
├── variables.tf
├── output.tf
├── terraform.tfvars
├── modules
│   ├── alb
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── output.tf
│   ├── asg
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── output.tf
│   └── launch-template
│       ├── main.tf
│       ├── variables.tf
│       ├── output.tf
│       └── user-data.sh
```

---

## ⚙️ Prerequisites

- Terraform (>= 1.x)
- AWS CLI
- AWS account with permissions

---

##  AWS Authentication

### Option 1
```
aws configure
```

### Option 2
```
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_DEFAULT_REGION="your-region"
```

---

##  Configure Variables

Edit terraform.tfvars:

```
environment       = "dev"
project_name      = "my-project"
owner             = "your-name"

subnet_ids        = ["subnet-xxxx", "subnet-yyyy"]
alb_sg_id         = "sg-xxxx"
vpc_id            = "vpc-xxxx"

lb_name           = "my-alb"
loadbalancer_type = "application"
lbtg_name         = "my-target-group"
protocol          = "HTTP"
path              = "/"
port              = 80
```

---

## How to Run

```
terraform init
terraform validate
terraform plan
terraform apply
```

---

## 🧹 Destroy

```
terraform destroy
```

---

## Tagging Strategy

```
locals {
  common_tags = {
    environment = var.environment
    project     = var.project_name
    owner       = var.owner
  }
}
```

---

