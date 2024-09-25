variable "ami" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "subnet_id" {
  type = string
}


variable "security_group" {
  type = string
}

variable "elastic_ip" {
  type = string
}

variable "key_name" {
  type = string
}

variable "associate_public_ip_address" {
  type = bool
}
variable "from_port" {
  type = number
}

variable "to_port" {
  type = number
}

variable "protocol" {
  type = string
}

variable "security_group_cidr_blocks" {
  type = string
}

variable "allocation_id" {
  type = string
}