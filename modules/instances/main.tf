resource "aws_instance" "BuildHost" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  key_name                    = var.key_name
  security_groups             = [var.security_group]
  associate_public_ip_address = var.associate_public_ip_address


  tags = {
    Name = "Monitoring Containers"
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

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.BuildHost.id
  allocation_id = var.elastic_ip
}