# Lyriq-Infrastructure

## Description
This Terraform project automates the provisioning of various AWS infrastructure components, including EC2 instances, S3 buckets, VPC, AutoScaling groups, IAM roles, Elastic IP, SQS, and SNS. EC2 and S3 resources are organized into modules for reusability and easier management. The project uses an S3 remote backend with DynamoDB state locking to manage the Terraform state. This README provides a high-level overview and key configuration elements. This project is still under development and will be updated on a regular basis.

## Table of Contents
- [Architecture](#architecture)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
- [Modules](#modules)
- [Variables](#variables)
- [Outputs](#outputs)
- [Contributing](#contributing)
- [License](#license)

## Architecture
This project provisions the following AWS components:
- **EC2 Instances**: Deployed within an AutoScaling group and associated with Elastic IPs.
- **S3 Buckets**: Provisioned for object storage.
- **VPC**: Custom VPC setup including subnets and security groups.
- **IAM Roles**: Roles and policies for EC2, S3, and other resources.
- **Elastic IP**: Static public IPs for EC2 instances.
- **SQS and SNS**: Message queuing and notification services for AutoScaling events.

## Prerequisites
- [Terraform](https://www.terraform.io/downloads.html) v1.2.0 or later.
- AWS CLI configured with appropriate credentials.
- An S3 bucket and DynamoDB table for state backend and state locking.

## Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/selelyriq/Lyriq-Infrastructure.git
   cd Lyriq-Infrastructure

	2.	Initialize Terraform:

terraform init


	3.	Create a terraform.tfvars file to specify your configuration values:

touch terraform.tfvars

Example terraform.tfvars:

region         = "us-west-2"
instance_type  = "t2.micro"
key_name       = "My_Keypair"
elastic_ip     = true



Usage

	1.	Plan the deployment:

terraform plan


	2.	Apply the configuration:

terraform apply


	3.	Destroy the infrastructure (optional):

terraform destroy



Modules

	•	Instances Module: Provisions EC2 instances, assigns Elastic IPs, and configures security groups.
	•	Buckets Module: Creates S3 buckets for object storage.

Modules can be customized by passing variables through the terraform.tfvars file.

Variables

Here are some key variables required for this project:

	•	region - AWS region to deploy the infrastructure.
	•	instance_type - The type of EC2 instance to provision.
	•	key_name - Name of the key pair for EC2.
	•	elastic_ip - Boolean to associate an Elastic IP with EC2.

For a full list of variables, see the variables.tf file.

Outputs

The following outputs are available:

	•	EC2 Instance IDs: IDs of the EC2 instances created.
	•	S3 Bucket Name: Name of the provisioned S3 bucket.
	•	Scaling Queue ARN: ARN of the SQS queue for AutoScaling events.
	•	Scaling Topic ARN: ARN of the SNS topic for AutoScaling notifications.

Contributing

Contributions are welcome! Please fork the repository and submit a pull request.

License

This project is licensed under the MIT License. See the LICENSE file for more information.

---

This README now includes the key configuration elements you provided, such as the remote backend details and core resources. Feel free to modify the variables and outputs as needed, especially once you finalize the `main.tf` file.