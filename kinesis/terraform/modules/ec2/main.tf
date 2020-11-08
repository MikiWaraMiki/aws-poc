########################
# Security Group
########################
locals {
  allow_ingress_ips   = length(var.allow_ingress_ips) > 0 ? var.allow_ingress_ips : ["0.0.0.0/0"]
  allow_ingress_ports = length(var.allow_ingress_ports) > 0 ? concat(var.allow_ingress_ports, [80, 443]) : [80, 443]
}
resource "aws_security_group" "ec2_security_group" {
  name        = "alb-sg-${var.pjprefix}"
  description = "Allow HTTP and HTTPS, allow ssh my ip"
  vpc_id      = var.vpc_id

  tags = {
    Name     = "ec2-sg-${var.pjprefix}"
    PJPrefix = "${var.pjprefix}"
  }
}
# Ingress Rules
resource "aws_security_group_rule" "allow_ingress" {
  count             = length(local.allow_ingress_ports)
  security_group_id = aws_security_group.ec2_security_group.id
  type              = "ingress"
  from_port         = element(local.allow_ingress_ports, count.index)
  to_port           = element(local.allow_ingress_ports, count.index)
  protocol          = "tcp"
  cidr_blocks       = local.allow_ingress_ips
}
# Egress Rules
resource "aws_security_group_rule" "allow_egress" {
  type              = "egress"
  security_group_id = aws_security_group.ec2_security_group.id
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}


##########################
# EC2
##########################
data "aws_ami" "latest_amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "block-device-mapping.volume-type"
    values = ["gp2"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-profile-${var.pjprefix}"
  role = var.role_name
}
resource "aws_instance" "main" {
  ami                    = data.aws_ami.latest_amazon_linux.image_id
  vpc_security_group_ids = [aws_security_group.ec2_security_group.id]
  subnet_id              = var.subnet_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.ec2_keypair.id
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  tags = {
    Name     = "ec2-${var.pjprefix}"
    PJPrefix = var.pjprefix
  }
}

resource "aws_eip" "ec2_eip" {
  instance = aws_instance.main.id
  vpc      = true
}

resource "aws_key_pair" "ec2_keypair" {
  key_name   = "key-pair-${var.pjprefix}"
  public_key = var.key_file
}
