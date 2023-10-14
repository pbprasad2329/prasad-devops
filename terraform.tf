# Initialize the Terraform AWS provider
provider "aws" {
  region = "ap-south-1"  # Change this to your desired AWS region
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
  ami           = "ami-0f5ee92e2d63afc18"  # Replace with your desired AMI ID
  instance_type = "t2.micro"
  subnet_id     = aws_default_subnet.default.id  # Use the default VPC's default subnet
  key_name      = "your-key-pair-name"  # Change this to your SSH key pair
  security_groups = [aws_security_group.instance_sg.id]

  tags = {
    Name = "public-instance"
  }
}

# Default VPC
resource "aws_default_vpc" "default" {
  tags = {
    Name = "default-vpc"
  }
}

# Default subnet
resource "aws_default_subnet" "default" {
  depends_on = [aws_default_vpc.default]
}
