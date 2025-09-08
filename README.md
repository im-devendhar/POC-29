# POC-29

## Project 29: Infrastructure as Code with Terraform for EC2 and S3

###  Background
Infrastructure as Code (IaC) standardizes provisioning. Terraform enables managing AWS resources using HCL (HashiCorp Configuration Language).

###  Objective
Provision a **VPC**, **EC2 instance**, and **S3 bucket** using Terraform.

###  Tools & Services
- Terraform  
- EC2  
- S3  
- IAM  

###  Implementation Steps
1. Install Terraform and initialize the AWS provider.
2. Write modules for EC2, VPC, and S3.
3. Use variables and outputs for modularity and reusability.
4. Apply the configuration and verify resources in the AWS Console.
5. Automate the deployment using AWS CodeBuild.

###  Hints
- Use **S3** and **DynamoDB** backend for Terraform state management.

###  Expected Outcome
Infrastructure is reproducibly deployed with a **single command**, ensuring consistency and automation.

---

Feel free to customize this further with badges, links to your modules, or screenshots if needed!
