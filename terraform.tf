# Initialize the Terraform AWS provider
provider "aws" {
  region = "ap-south-1"  # Change this to your desired AWS region
}

# Create a VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"  # You can choose your own CIDR block
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "my-vpc"
  }
}

# Create a public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.0.0/24"  # Choose a subnet CIDR block within your VPC range
  availability_zone = "ap-south-1a"  # Change this to an available AZ in your region
  map_public_ip_on_launch = true  # Enable automatic public IP assignment
  tags = {
    Name = "public-subnet"
  }
}

# Create a private subnet
resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"  # Choose a subnet CIDR block within your VPC range
  availability_zone = "ap-south-1b"  # Change this to an available AZ in your region
  tags = {
    Name = "private-subnet"
  }
}

# Create a security group for the EC2 instances
resource "aws_security_group" "instance_sg" {
  name        = "instance-sg"
  description = "Allow inbound SSH and HTTP traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create public EC2 instance
resource "aws_instance" "public_instance" {
  ami           = "ami-0f5ee92e2d63afc18"  
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet.id
  key_name      = "your-key-pair-name"  # Change this to your SSH key pair
  security_groups = [aws_security_group.instance_sg.id]

  tags = {
    Name = "public-instance"
  }
}
