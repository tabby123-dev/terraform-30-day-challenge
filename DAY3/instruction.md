# Deploy Your First Web Server Using Terraform on AWS

In this tutorial, you will learn how to deploy a web server in a **public subnet** using Terraform and verify that it is accessible from the internet.  

We will cover:  
1. Creating a **VPC** in the `us-east-1` region.  
2. Creating **one public subnet**.  
3. Setting up a **web security group (SG)** with inbound rules for **ports 80, 443, and 22**.  
4. Deploying a **web server** and testing connectivity.  

---

## Architecture Overview

<img width="571" height="341" alt="AWSVPC drawio" src="https://github.com/user-attachments/assets/7ce2a0b3-7007-4944-a240-45b9cc8cf674" />


---

## Steps

### 1. Initialize Terraform
Initialize Terraform and configure the AWS provider.

<img width="439" height="227" alt="image" src="https://github.com/user-attachments/assets/d806b10f-7234-4662-86e4-1d7c7a095e7e" />


---

### 2. Create a VPC
Create a VPC in the `us-east-1` region.

<img width="272" height="382" alt="image" src="https://github.com/user-attachments/assets/51858055-d801-4791-9865-de7fd633a221" />



---

### 3. Add a Public Subnet
Add one public subnet to the VPC.

<img width="271" height="165" alt="image" src="https://github.com/user-attachments/assets/1f39dcaa-3eea-4636-83d7-cb5f56c152ea" />



---

### 4. Create a Security Group
Set up a security group allowing inbound traffic on ports 80 (HTTP), 443 (HTTPS), and 22 (SSH).

<img width="464" height="545" alt="image" src="https://github.com/user-attachments/assets/286df39c-5b67-45ac-9d9a-f6a51fc45aa8" />


---

### 5. Deploy the Web Server
Deploy the web server in the public subnet using Terraform.

<img width="790" height="683" alt="Screenshot 2026-03-19 011142" src="https://github.com/user-attachments/assets/9387e243-4eeb-4a86-a4db-634a09d2b313" />




---

### 6. Test Connectivity
- Access the web server via its public IP or DNS.  
- Verify that ports 80 and 443 are reachable.  
```
http://publicipof server
```



---

### Notes
- Ensure your AWS credentials are configured before running Terraform.  
- Modify the Terraform scripts as needed for your environment.
