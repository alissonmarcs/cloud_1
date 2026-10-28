resource "aws_eip" "web" {
  count  = 2
  domain = "vpc"

  tags = {
    Name = "web-server-eip-${count.index + 1}"
  }
}

resource "aws_eip_association" "web" {
  count         = 2
  instance_id   = aws_instance.ubuntu_server_22_04[count.index].id
  allocation_id = aws_eip.web[count.index].id
}

output "elastic_ips" {
  value = aws_eip.web[*].public_ip
}

resource "aws_key_pair" "deployer" {
  key_name   = "alisson_public_key"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP5ZJ3j8/8VY7wUpRqX2+oLlB0jzdc/dkpkKDjSzI1lq edu@DESKTOP-SVNSP9C"
}

resource "aws_instance" "ubuntu_server_22_04" {
  count = 2

  ami           = data.aws_ami.ubuntu_22_04_x86.id
  instance_type = "t3.micro"

  depends_on = [aws_key_pair.deployer, aws_security_group.allow_tls]

  vpc_security_group_ids = [aws_security_group.allow_tls.id]

  key_name  = aws_key_pair.deployer.key_name
  subnet_id = "subnet-0d4b59b467f99e68e"

  availability_zone = "us-east-2a"

  tags = {
    Name = "Ubuntu-22.04-x86-${count.index + 1}"
  }
}

locals {
  allowed_ports = {
    ssh   = 22
    http  = 80
    https = 443
  }
}

resource "aws_security_group" "allow_tls" {
  name        = "demooo"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = "vpc-0087c6616897d8db9"

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  for_each = local.allowed_ports

  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = each.value
  to_port           = each.value
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  for_each = local.allowed_ports

  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp" # semantically equivalent to all ports
  from_port         = each.value
  to_port           = each.value
}
