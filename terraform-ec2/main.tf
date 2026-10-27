
resource "aws_key_pair" "deployer" {
  key_name   = "alisson_public_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCrcr2xL2Ty95VeVW/axP8D9eo/8s9co6FP/JYo5O5xy8T32cz1X0wTy0VeiDhwKfzvsxBJGN4rRgDlY3n6b+Q2fkBjYWLV9nrvUoeJwUj/02oaUGbRQsw+42kpxteedzsD9berOgaFl3h8UC1CfOuy9h22E43eWxkHcqt3jZW7PNDduYCEESrN0Wc6r1uttndHrvaDZtyrXBt90XlhnSSVFnvFWk08szbg0E/CwYWy6DA5CBkTSeLrPI4GU7+5bctkwIj9lyG0hfwvWgh+Z+AkumV1Os4AA7XJFKlJgRD4JfAMpZf3LEvLQ9/Ke3v7dfjLH49Dl96V/IXJ5G3pKPc0XobMl5c98UrnlQpDA69f/nKO3k7iUTdzQE65sXkpzneroyYLcHicZV9n/d5eMbzeQQIZH71ioHU6hZiy0daKnfJwkXKKAnUW3dnRSPz9wO1531x7ctyEVsi0Fk470yJplwY3DrnTtmiFAYHg1oWeIz9mV3zdx/LOxyKksJWS4sDDfyb5BcP2UMbl+4r1cdR6wLLSchMQEtIK6zl0yj2ojf1Ls87GX3QAjPW0mNuouPF4SPc3HNmMuU6SONydwMqUsNuFRQEyBEYcrx0KyIw/L7z7SWqCrTT8CjT0P2GNwr1n1EYHeb2FjibgCqa560J5F9nnY/IAuzuq8kNS92lSCQ== your_email@example.com"
}

resource "aws_instance" "ubuntu_server_22_04" {
  ami           = data.aws_ami.ubuntu_22_04_x86.id
  instance_type = "t3.micro"
  associate_public_ip_address = true

  depends_on = [aws_key_pair.deployer,aws_security_group.allow_tls]

  vpc_security_group_ids = [aws_security_group.allow_tls.id]

  key_name = aws_key_pair.deployer.key_name
  subnet_id = "subnet-0d5629472099d29d4"

  availability_zone = "us-east-2a"

  tags = {
    Name = "Ubuntu-22.04-x86"
  }
}

resource "aws_security_group" "allow_tls" {
  name        = "demooo"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = "vpc-09c32b01109493831"

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = -1
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
