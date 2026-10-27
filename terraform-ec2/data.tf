data "aws_ami" "ubuntu_22_04_x86" {
  most_recent = true
  owners      = ["099720109477"] # ID da conta oficial da Canonical (criadora do Ubuntu)

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
