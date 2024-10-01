resource "aws_instance" "BuildHost" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  key_name                    = var.key_name
  security_groups             = [var.security_group]
  associate_public_ip_address = var.associate_public_ip_address


  tags = {
    Name = "Build Host"
  }
}

resource "aws_instance" "Webserver" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  key_name                    = var.key_name
  security_groups             = [var.security_group]
  associate_public_ip_address = var.associate_public_ip_address

  tags = {
    Name = "Webserver"
  }
}

resource "aws_instance" "Monitoring" {
  ami             = var.ami
  instance_type   = var.instance_type
  subnet_id       = var.subnet_id
  key_name        = var.key_name
  security_groups = [var.security_group]
  # associate_public_ip_address = true
  tags = {
    Name = "Monitoring"
  }
}

output "build_instance_id" {
  value = aws_instance.BuildHost.id
}

output "monitoring_instance_id" {
  value = aws_instance.Monitoring.id
}

# resource "aws_eip_association" "eip_assoc" {
#   instance_id   = aws_instance.BuildHost.id
#   allocation_id = var.elastic_ip
# }