variable "vpc_id" {
  type = string
}

variable "elastic_ip" {
  type = string
}

variable "Public_subnet" {
  type = string
}

variable "Private_subnet" {
  type = string
}

variable "Region" {
  type = string
}

variable "cidr_blocks" {
  description = "security group cidr"
  type        = string
}
  