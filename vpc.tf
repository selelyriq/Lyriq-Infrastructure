resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_blocks
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "Public_subnet" {
  # count = length(var.Public_subnet)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.Public_subnet
  availability_zone = "us-east-1a"

  tags = {
    Name = "${local.setup_name} - Public subnet"
  }
  # tags {
  #   Environment "staging"
  # }
}

resource "aws_subnet" "Private_subnet" {
  # count = length(var.Private_subnet)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.Private_subnet
  availability_zone = "us-east-1a"

  tags = {
    Name = "${local.setup_name} - Private subnet"
  }
}

# data "aws_vpc" "default" {
#   id = aws_vpc.main.id
# }

output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_id" {
  value = aws_subnet.Public_subnet.id
}

output "private_subnet_id" {
  value = aws_subnet.Private_subnet.id
}

locals {
  mtc_igw_id = "mtc_igw-5369"
}

resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.default.id
  }

  tags = {
    Name = "2nd Route Table"
  }
}
