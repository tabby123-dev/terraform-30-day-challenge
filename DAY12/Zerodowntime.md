## The Problem — Default Downtime

The “destroy, then create” approach is unreliable in real production environments where downtime is not an acceptable solution. When you create or update a resource, Terraform may destroy the existing resource first (causing downtime) and then create the new resource or updated version.

## Create-Before-Destroy Implementation

## Code Example
Refer to the files in the repo.



## Blue/Green Configuration

The switch from blue to green is very fast, and no major delay is observed during the process.

## Limitations of Create-Before-Destroy

- Some resources cannot exist in duplicate at the same time (e.g., S3 bucket names and load balancer names must be unique).
- It can cause drift while old resources are still running until the new ones are fully created.
- Zero-downtime does not work well with Auto Scaling policies, because it can reset your ASG desired capacity to the `min_size`.
- Rollbacks can be complex due to resource dependencies.
