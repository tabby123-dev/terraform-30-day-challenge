# Terraform State Management and AWS ELB Setup

Today’s task focused on managing state files in Terraform. In any environment, handling the state of all resources at once can be challenging, but Terraform state files enable us to manage resources efficiently across different environments.

## Why Managing Terraform State Files is Critical

- Managing Terraform state files correctly is essential for reliable infrastructure workflows.  
- You should **never commit state files to Git** because they often contain sensitive data like credentials and resource details and can easily cause conflicts in team environments.  
- Instead, use **remote backends** such as Amazon S3, which centralize and securely store state for shared access.  
- **State locking** is equally important, as it prevents multiple users or processes from modifying the same state simultaneously, reducing the risk of corruption and ensuring consistency during deployments.

## What Happens When the Statefile is Edited

Since the statefile contains snapshots of your infrastructure, manually editing it can cause Terraform to detect inconsistencies, resulting in failed plans and errors.

## AWS Elastic Load Balancer (ELB) Setup

As a continuation of Day 4, today I added an **AWS Elastic Load Balancer** to my architecture using Terraform. I used the state file to read the current state of the resources deployed on Day 4. I also outlined the steps for creating the ELB and integrating it with the Auto Scaling Group.
<img width="894" height="694" alt="image" src="https://github.com/user-attachments/assets/e325e351-b5dc-433a-8dbb-4685fd3400ff" />

### Components

- **Application Load Balancer (ALB)** – Acts as a point of entry for incoming traffic and distributes traffic across multiple instances for high availability.  
- **Target Group** – Contains a definition of EC2 instances that receive traffic from the ALB.  
- **Listener** – Attached to the ALB and checks/listens for incoming traffic on port 443, forwarding the request to the appropriate target group based on defined rules.

### Flow of Connection
ALB → Listener → Target Group → EC2 Instance managed by Auto Scaling Group


This setup ensures **scalability and load balancing** in your infrastructure.
The Terrfaorm code for the setup can be found in the DAY5 folder.
