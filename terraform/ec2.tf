data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "tls_private_key" "jenkins_ec2_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "jenkins_private_key" {
  content         = tls_private_key.jenkins_ec2_private_key.private_key_pem
  filename        = "jenkins_key.pem"
  file_permission = "0400"

}

resource "aws_key_pair" "jenkins_ec2_public_key" {
  key_name   = "jenkins_ec2_public_key"
  public_key = tls_private_key.jenkins_ec2_private_key.public_key_openssh

}

resource "aws_instance" "jenkins_ec2" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.jenkins_ec2_public_key.key_name
  subnet_id                   = aws_subnet.retailrec_subnet_public_a.id
  vpc_security_group_ids      = [aws_security_group.retailrec_jenkins_sg.id]
  associate_public_ip_address = true
  tags                        = merge(var.common_tags, { Name = "jenkins_ec2" })

}