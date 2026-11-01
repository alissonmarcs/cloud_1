resource "aws_key_pair" "deployer" {
  key_name   = "alisson_public_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDbeYw4ua8rdxBnohC1nsW+qMYmVpSZq2OvZU3la91kRgyHxYS2dV9mvzeN665OAu65XkuZtyrU3N7JSL/hZp65hIailSlNHZAMhq+zrBruKgiqgQW/Cx1a9QhPcN+mmGxFyBZ+yfhBYjRfdRt1CMSK6S1U77Ufh3guCoGxFsyJuSVOE5WxGITpLsvX+dynNekJzQpvpKoGM7n+O/VFj1xuIf4uuel7JQbE/gDXVUoVSHT+5csEsHmFFGwj76eLjuRlYpfanYlPcSn/+re09aFsugXGMwHv/oU3bxflxjtzVOQO+m05/YNHJiOnLfUVfDbZsgiu5coe+fTkyTQMoACVGFIg3OA/e5Y8DIdyLcx0IdB8zRQ3YVf2aZ5wJyqOIM0Av106oXhV+n+Sr9oXHD4gMtvg8HPZK9kIyEnQlgILobJ+8jwzwmpAzIcYEXXwvaFEIe5YXPH0J60qphFnJVd/yr/LFnwrVx718YFqyAhs2sUPsKrgu260l3csH3Ro0gzfZ37G9dyEoroyvHcEbRzI6AdehAVDwANPGHdoD1vc22bIu9Ivo6fzXdlNaS9gimcW/ZP+t1mG/VrDdz7nvG6UNPcWtsCFEXwSpdp2RByjkaw9FFkg+ZVcT7e9ziO/oJsepGkvsdKn8S5tHWag7AcRYluK8PaxFcyZ+nx4zZdMCQ== alissonmarcos249@gmail.com"
}

resource "aws_instance" "ubuntu_server_22_04" {

  ami           = data.aws_ami.ubuntu_22_04_x86.id
  instance_type = "t3.micro"

  depends_on = [aws_key_pair.deployer, aws_security_group.allow_tls]

  vpc_security_group_ids = [aws_security_group.allow_tls.id]

  key_name  = aws_key_pair.deployer.key_name
  subnet_id = data.aws_subnet.selected.id

  availability_zone = "us-east-2a"

  associate_public_ip_address = true

  tags = {
    Name = "Ubuntu-22.04-x86"
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
  value       = aws_instance.ubuntu_server_22_04.public_ip
  description = "O endereço IP público da instância EC2"
}

