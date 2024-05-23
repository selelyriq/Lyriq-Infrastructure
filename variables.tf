# variable "EC2IP" {
#   description = ""
#   type        = string
# }
# variable "VPC" {
#   type = string
#   default = "172.128.0.0/16"
# }

variable "Public_subnet" {
  type = string
  default = "172.31.128.0/20"
}

variable "Private_subnet" {
  type = string
  default = "172.31.64.0/20"
}

variable "Region" {
  type = string
  default = "us-east-1a"
}