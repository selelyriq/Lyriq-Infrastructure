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



resource "aws_instance" "Infrastructure" {
  ami           = "ami-04b70fa74e45c3917"
  instance_type = "t2.medium"
  subnet_id = aws_subnet.Public_subnet.id

  tags = {
    Name = "Base EC2 Instance"
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

