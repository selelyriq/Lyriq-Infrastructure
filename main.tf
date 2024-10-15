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
  allocation_id               = aws_eip.elastic_ip.id
}

module "autoscaling" {
  source             = "./resources/autoscaling"
  public_subnet_id   = aws_subnet.Public_subnet.id
  private_subnet_id  = aws_subnet.Private_subnet.id
  scaling_queue_arn  = aws_sqs_queue.scaling_queue.arn
  iam_role_arn       = aws_iam_role.autoscaling_role.arn
}

resource "aws_eip" "elastic_ip" {
  instance = module.instances.build_instance_id
}

resource "aws_iam_role" "autoscaling_role" {
  name = "autoscaling_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "autoscaling.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_sqs_queue" "scaling_queue" {
  name = "scaling_queue"
}

resource "aws_autoscaling_notification" "scaling_notification" {
  group_names = [module.autoscaling.autoscaling_group_name]
  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCHING",
    "autoscaling:EC2_INSTANCE_TERMINATING",
  ]
  topic_arn = aws_sns_topic.scaling_topic.arn
}

output "scaling_topic_arn" {
  value = aws_sns_topic.scaling_topic.arn
}

resource "aws_sns_topic" "scaling_topic" {
  name = "scaling_topic"
}

output "scaling_queue_arn" {
  value = aws_sqs_queue.scaling_queue.arn
}
