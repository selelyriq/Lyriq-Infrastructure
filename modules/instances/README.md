
# EC2 Instance Module

## Description
This Terraform module provisions multiple AWS EC2 instances, including a Build Host, Webserver, and Monitoring instance. Each instance is deployed within a specified subnet, associated with a security group, and can optionally have a public IP address.

## Table of Contents
- [Architecture](#architecture)
- [Prerequisites](#prerequisites)
- [Usage](#usage)
- [Variables](#variables)
- [Outputs](#outputs)
- [License](#license)

## Architecture
This module provisions the following EC2 instances:
- **Build Host**: General-purpose instance for build tasks.
- **Webserver**: Instance designated for hosting web applications.
- **Monitoring**: Instance for monitoring infrastructure components.

## Prerequisites
- [Terraform](https://www.terraform.io/downloads.html)
- AWS CLI configured with appropriate credentials.

## Usage

1. **Add the module to your Terraform configuration:**
   ```hcl
   module "ec2_instances" {
     source = "./modules/instances"
     ami = "ami-12345678"
     instance_type = "t2.micro"
     subnet_id = "subnet-12345678"
     key_name = "My_Keypair"
     security_group = "sg-12345678"
     associate_public_ip_address = true
   }

	2.	Initialize and apply the module:

terraform init
terraform apply



Variables

The following variables are required to configure the EC2 instances:

	•	ami - AMI ID for the instances.
	•	instance_type - Type of EC2 instance (e.g., t2.micro).
	•	subnet_id - Subnet in which to deploy the instances.
	•	key_name - Name of the key pair for SSH access.
	•	security_group - Security group to associate with the instances.
	•	associate_public_ip_address - Boolean to enable public IP for the instances.

Outputs

The module provides the following outputs:

	•	build_instance_id - ID of the Build Host instance.
	•	monitoring_instance_id - ID of the Monitoring instance.

License

This module is licensed under the MIT License.

---

This README provides a concise guide for using the EC2 instance module and explains the purpose of each resource. Let me know if you need further adjustments!