terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
}

data "aws_region" "current" {}

data "aws_vpc" "default" {
  default = true
}

resource "aws_subnet" "Public_subnet" {
  # count = length(var.Public_subnet)
  vpc_id = data.aws_vpc.default.id
  cidr_block = var.Public_subnet
  availability_zone = "us-east-1a"

  tags = {
    Name = "Public subnet"
  }
}

resource "aws_subnet" "Private_subnet" {
  # count = length(var.Private_subnet)
  vpc_id = data.aws_vpc.default.id
  cidr_block = var.Private_subnet
  availability_zone = "us-east-1a"

  tags = {
    Name = "Private subnet"
  }
}

# resource "aws_eip" "existing" {
#   public_ip = var.elastic_ip
# }

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.Jumphost.id
  allocation_id = var.elastic_ip
}

resource "aws_instance" "Jumphost" {
  ami           = "ami-04b70fa74e45c3917"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.Public_subnet.id
  key_name = "My_Keypair"
  security_groups = [aws_security_group.Allow_Jumphost_SSH.id]
  user_data = file("/Users/lyriqsele/Documents/Code/My_Infrastructure/ssh_script")
  
  tags = {
    Name = "Jumphost"
  }
}



# resource "aws_security_group" "Allow_Jumphost_SSH" {
#   name = "Allow_Jumphost"
#   description = "Allow SSH access into jumphost"
#   vpc_id = data.aws_vpc.default.id

#   tags = {
#     Name = "Allow_Jumphost_SSH"
#   }
# }

# resource "aws_vpc_security_group_ingress_rule" "Allow_SSh" {
#   ip_protocol       = "tcp"
#   security_group_id = aws_security_group.Allow_Jumphost_SSH.id  # Ensure this points to the correct security group ID
#   from_port         = 22
#   to_port           = 22
#   cidr_ipv4 = var.cidr_blocks# Specify the correct IP address range
# }


resource "aws_security_group" "Allow_Jumphost_SSH" {
  name        = "Allow_Jumphost_SSH"
  description = "Allow SSH access from a specific IP address range"

  // Define the inbound rule for SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["18.206.107.24/29"]  # Specify your specific IP address or range
  }

  // Optionally, define egress rules if needed
}


resource "aws_instance" "Infrastructure" {
  ami           = "ami-06b08f0bf3eaf34a9"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.Public_subnet.id
  key_name = "My_Keypair"
  security_groups = [aws_security_group.Jumphost_to_Monitoring.id]


  tags = {
    Name = "Monitoring Containers"
  }
}

# resource "tls_private_key" "Infrastructure_keypair" {
#   key_name   = var.key_name
#   public_key = tls_private_key
# }

resource "aws_security_group" "Jumphost_to_Monitoring" {
  name        = "Allow_Jumphost_to_monitoring"
  description = "Allow SSH access from Jumphost to monitoring server"

  // Define the inbound rule for SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["35.173.169.108/32"]  # Specify your specific IP address or range
  }
}
# Using Data Source to pull default internet gateway
locals {
  mtc_igw_id = "mtc_igw-5369"
}

data "aws_internet_gateway" "default" {
  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = data.aws_internet_gateway.default.id
#   }

#   tags = {
#     Name = "2nd Route Table"
#   }
# }

