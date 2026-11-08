variable "full_path_ssh_public_key" {
 type = string
}

variable "instances" {

 type = map(string)

}

resource "aws_key_pair" "deployer" {
  key_name   = "alisson_public_key"
  public_key = file(var.full_path_ssh_public_key)
}

resource "aws_instance" "ubuntu_server_22_04" {

  for_each = var.instances

  instance_type = each.value
  ami           = data.aws_ami.ubuntu_22_04_x86.id

  depends_on = [aws_key_pair.deployer, aws_security_group.allow_tls]

  vpc_security_group_ids = [aws_security_group.allow_tls.id]

  key_name  = aws_key_pair.deployer.key_name
  subnet_id = data.aws_subnet.selected.id

  availability_zone = "us-east-2a"

  associate_public_ip_address = true

  tags = {
    Name = each.key
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
  vpc_id      = data.aws_vpc.default.id

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

output "instance_public_ip" {
  description = "O endereço IP público da instância EC2"
  value       = {
   for key, value in aws_instance.ubuntu_server_22_04 :
    key => value.public_ip
  }
}

