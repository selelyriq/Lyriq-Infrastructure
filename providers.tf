provider "aws" {
  alias  = "east"
  region = "us-east-1" // Replace with your AWS region
  // You can also configure AWS credentials here if needed
}

provider "aws" {
  alias  = "west"
  region = "us-west-1"
}