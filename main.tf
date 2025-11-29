provider "aws" {
  region = "us-east-1"
}

# --- 1. Get the latest Ubuntu Image (Required!) ---
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# --- 2. Security Group (Firewall) ---
resource "aws_security_group" "strapi_sg" {
  name        = "strapi-interview-sg"
  description = "Allow SSH and HTTP traffic"

  # Allow Strapi (1337)
  ingress {
    from_port   = 1337
    to_port     = 1337
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow SSH (22) - CRITICAL for manual install
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow Outgoing
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# --- 3. The Server (EC2) ---
resource "aws_instance" "strapi_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.medium"
  vpc_security_group_ids = [aws_security_group.strapi_sg.id]

  # --- CRITICAL: Attach the key you created in AWS Console ---
  key_name = "strapi-key" 

  tags = {
    Name = "Strapi-Interview-Demo"
  }

  # Note: I REMOVED the user_data script.
  # We will install Strapi manually via SSH to make sure it works.
}

# --- 4. Outputs ---
output "strapi_url" {
  value = "http://${aws_instance.strapi_server.public_ip}:1337"
}

output "ssh_command" {
  value = "ssh -i strapi-key.pem ubuntu@${aws_instance.strapi_server.public_ip}"
}