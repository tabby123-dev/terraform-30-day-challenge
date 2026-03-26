 Terraform Conditional (Ternary) Expressions and Conditional Resources

## Conditional (Ternary) Expression

A conditional (ternary) expression helps implement conditional logic instead of traditional `if/else` statements.

### Syntax

```
condition ? value_if_true : value_if_false
```

**Meaning:**  
If the condition is true, the first value is used. If false, the second value is used.

---

## Example: Using Locals with Conditional Logic

```hcl
locals {
  is_production = var.environment == "production"

  instance_type = local.is_production ? "t2.medium" : "t2.micro"
  min_size      = local.is_production ? 3 : 1
  max_size      = local.is_production ? 10 : 3

  enable_monitoring = local.is_production || var.enable_detailed_monitoring
}
```

---

## Referencing Locals in Resources

```hcl
resource "aws_launch_template" "template1" {
  name_prefix   = "${var.launch_template_name}-dev1"
  image_id      = var.ami_id
  instance_type = local.instance_type
  vpc_security_group_ids = var.security_group_ids

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = var.instance_name
    }
  }

  user_data = base64encode(templatefile("${path.module}/userdata.sh", {
    launch_template_name = var.launch_template_name
  }))
}
```

---

## Example: Conditional Resource Configuration

```hcl
variable "environment" {
  type    = string
  default = "dev"
}

locals {
  instance_type     = var.environment == "production" ? "t2.medium" : "t2.small"
  min_cluster_size  = var.environment == "production" ? 3 : 1
  max_cluster_size  = var.environment == "production" ? 10 : 3
}

resource "aws_instance" "web" {
  instance_type = local.instance_type
  ami           = "ami-0ec10929233384c7f"
}
```

---

## Key Concept

- If a ternary condition evaluates:
  - **True → 1 (or first value)**
  - **False → 0 (or second value)**

---

## Writing on Medium

### Difference Between Conditional Expression and Conditional Resource Creation

- **Conditional Expression (`condition ? a : b`)**
  - Chooses between values (strings, numbers, maps, object attributes)

- **Conditional Resource Creation (`count` / `for_each`)**
  - Controls whether Terraform creates resource instances at all

---

## Challenges

- Validation blocks rejecting “valid” values  
  - **Solution:** Normalize input inside validation



