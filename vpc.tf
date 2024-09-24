resource "aws_vpc" "vpc" {

  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_subnet" "Public_subnet" {
  # count = length(var.Public_subnet)
  vpc_id            = data.aws_vpc.default.id
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
  vpc_id            = data.aws_vpc.default.id
  cidr_block        = var.Private_subnet
  availability_zone = "us-east-1a"

  tags = {
    Name = "${local.setup_name} - Private subnet"
  }
}

data "aws_vpc" "default" {
  default = true
}

output "vpc_id" {
  value = data.aws_vpc.default
}

locals {
  mtc_igw_id = "mtc_igw-5369"
}

data "aws_internet_gateway" "default" {
  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_route_table" "route_table" {
  vpc_id = data.aws_vpc.default.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = data.aws_internet_gateway.default.id
  }

  tags = {
    Name = "2nd Route Table"
  }
}
