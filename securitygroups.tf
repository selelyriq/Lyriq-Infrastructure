resource "aws_security_group" "Jumphost_to_Monitoring" {
  vpc_id      = aws_vpc.main.id
  name        = "Allow_Jumphost_to_monitoring"
  description = "Allow SSH access from Jumphost to monitoring server"

  // Define the inbound rule for SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "security_group_id" {
  value = aws_security_group.Jumphost_to_Monitoring.id
}

resource "aws_security_group" "Webserver" {
  vpc_id = aws_vpc.main.id
  name   = "Allow_Webserver"


  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}