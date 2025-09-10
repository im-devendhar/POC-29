# Specify the AWS provider and region
provider "aws" {
  region = "us-east-1"
}

# Create a custom VPC with a CIDR block
resource "aws_vpc" "custom_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Create a subnet within the custom VPC
resource "aws_subnet" "custom_subnet" {
  vpc_id     = aws_vpc.custom_vpc.id
  cidr_block = "10.0.1.0/24"
}

# Create an Internet Gateway and attach it to the VPC
resource "aws_internet_gateway" "custom_igw" {
  vpc_id = aws_vpc.custom_vpc.id
}

# Create a route table for the VPC with a route to the Internet
resource "aws_route_table" "custom_rt" {
  vpc_id = aws_vpc.custom_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.custom_igw.id
  }
}

# Associate the route table with the subnet
resource "aws_route_table_association" "custom_rta" {
  subnet_id      = aws_subnet.custom_subnet.id
  route_table_id = aws_route_table.custom_rt.id
}

# Create a security group that allows SSH access
resource "aws_security_group" "custom_sg" {
  name        = "custom_sg"
  description = "Allow SSH"
  vpc_id      = aws_vpc.custom_vpc.id

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

# Launch an EC2 instance in the custom subnet with the security group
resource "aws_instance" "custom_instance" {
  ami                    = "resolve:ssm:/aws/service/canonical/ubuntu/server/22.04/stable/current/amd64/hvm/ebs-gp2/ami-id"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.custom_subnet.id
  vpc_security_group_ids = [aws_security_group.custom_sg.id]
}

# Create an S3 bucket
resource "aws_s3_bucket" "custom_bucket" {
  bucket = "devendhar-custom-bucket"
}

