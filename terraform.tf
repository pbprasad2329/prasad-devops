# Initialize the Terraform AWS provider
provider "aws" {
  region = "ap-south-1"  # Change this to your desired AWS region
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
