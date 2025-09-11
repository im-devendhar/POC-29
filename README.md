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
Here's the README file content for your **Terraform POC on AWS**, formatted for clarity and documentation purposes:

---

# Terraform POC on AWS 

## Step 1: Provider
```hcl
provider "aws" {
  region = "us-east-1"
}
```
Use AWS in the `us-east-1` region (N. Virginia). All resources will be created here.

---

## Step 2: VPC (Virtual Private Cloud)
```hcl
resource "aws_vpc" "POC_vpc" {
  cidr_block = "10.0.0.0/16"
}
```
Creates a private network with IP range `10.0.0.0/16`. Think of it as your own mini data center in the cloud.

---

## Step 3: Subnet
```hcl
resource "aws_subnet" "POC_subnet" {
  vpc_id     = aws_vpc.POC_vpc.id
  cidr_block = "10.0.1.0/24"
}
```
A subnet is a smaller network inside the VPC. EC2 instance will reside here.

---

## Step 4: Internet Gateway
```hcl
resource "aws_internet_gateway" "POC_igw" {
  vpc_id = aws_vpc.POC_vpc.id
}
```
Allows resources in the VPC to access the internet.

---

## Step 5: Route Table
```hcl
resource "aws_route_table" "POC_rt" {
  vpc_id = aws_vpc.POC_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.POC_igw.id
  }
}
```
Defines traffic flow. All traffic (`0.0.0.0/0`) is routed to the Internet Gateway.

---

## Step 6: Route Table Association
```hcl
resource "aws_route_table_association" "POC_rta" {
  subnet_id      = aws_subnet.POC_subnet.id
  route_table_id = aws_route_table.POC_rt.id
}
```
Connects the subnet to the route table for internet access.

---

## Step 7: Security Group
```hcl
resource "aws_security_group" "POC_sg" {
  name        = "POC_sg"
  description = "Allow SSH"
  vpc_id      = aws_vpc.POC_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```
Firewall for EC2. Allows SSH access from anywhere and outbound traffic.

---

## Step 8: EC2 Instance
```hcl
resource "aws_instance" "POC_instance" {
  ami                    = "resolve:ssm:/aws/service/canonical/ubuntu/server/22.04/stable/current/amd64/hvm/ebs-gp2/ami-id"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.POC_subnet.id
  vpc_security_group_ids = [aws_security_group.POC_sg.id]
}
```
Launches an Ubuntu 22.04 EC2 instance (free-tier eligible). Accessible via SSH.

---

## Step 9: S3 Bucket
```hcl
resource "aws_s3_bucket" "POC_bucket" {
  bucket = "devendhar-poc-bucket-641"
}
```
Creates an S3 bucket for storage (files, logs, backups, etc.).

---

## Final Picture
 VPC with subnet and internet access  
 Route table + Internet Gateway for connectivity  
 Security Group allowing SSH  
 EC2 instance running in the subnet  
 S3 bucket for storage  

Everything is automated using **Terraform Infrastructure as Code** 

---


