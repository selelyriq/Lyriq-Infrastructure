terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"

  backend "s3" {
    bucket         = "mytfstatebackend"        // Replace with your actual S3 bucket name
    key            = "state/terraform.tfstate" // Replace with your desired state file path/key
    region         = "us-east-1"               // Replace with your AWS region
    dynamodb_table = "tfstatebackend"          // Replace with your DynamoDB table name for state locking
    encrypt        = true                      // Optional: Set to true for encryption
  }
}

locals {
  setup_name = "my_infrastructure"
}

locals {
  region = ["us-east-1", "us-west-1"]
}

provider "aws" {
  region = "us-east-1" // Replace with your AWS region
  // You can also configure AWS credentials here if needed
}

module "instances" {
  source                      = "./modules/instances"
  ami                         = "ami-06b08f0bf3eaf34a9"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.Public_subnet.id
  key_name                    = "My_Keypair"
  elastic_ip                  = var.elastic_ip
  associate_public_ip_address = true
  security_group              = aws_security_group.Jumphost_to_Monitoring.id
  security_group_cidr_blocks  = "0.0.0.0/0"
  from_port                   = 22
  to_port                     = 22
  protocol                    = "tcp"
}

module "buckets" {
  source      = "./modules/buckets"
  bucket_name = "my_bucket"
}