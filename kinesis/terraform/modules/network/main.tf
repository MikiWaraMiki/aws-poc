#######################
# Create VPC
#######################
resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = var.instance_tenancy

  tags = {
    PJPrefix = var.pjprefix
    Name     = "vpc-${var.pjprefix}"
  }
}
# IGW
resource "aws_internet_gateway" "vpc_igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    "Name"     = "igw-${var.pjprefix}"
    "PJPrefix" = var.pjprefix
  }
}


################################
# Create Subnet and route table
################################
resource "aws_subnet" "ec2_subnets" {
  count             = length(var.ec2_subnets)
  vpc_id            = aws_vpc.main.id
  availability_zone = "${lookup(element(var.ec2_subnets, count.index), "az")}"
  cidr_block        = "${lookup(element(var.ec2_subnets, count.index), "cidr")}"
  tags = {
    "PJPrefix" = "${var.pjprefix}"
    "Name"     = "subnet-ec2-${var.pjprefix}"
  }
}
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

  tags = {
    "Name"     = "rt-public-${var.pjprefix}"
    "PJPrefix" = var.pjprefix
  }
}
resource "aws_route" "route_for_public" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.vpc_igw.id

  # timeout5分に設定
  timeouts {
    create = "5m"
  }
}
resource "aws_route_table_association" "route_table_association_for_public" {
  count          = length(aws_subnet.ec2_subnets.*.id)
  subnet_id      = element(aws_subnet.ec2_subnets.*.id, count.index)
  route_table_id = aws_route_table.public_route_table.id
}


#######################
# ACL
#######################
resource "aws_network_acl" "main_acl" {
  vpc_id     = aws_vpc.main.id
  subnet_ids = aws_subnet.ec2_subnets.*.id
  tags = {
    Name     = "acl-${var.pjprefix}"
    PJPrefix = var.pjprefix
  }
}
# Default White list
resource "aws_network_acl_rule" "ingress_allow_rule" {
  network_acl_id = aws_network_acl.main_acl.id
  rule_number    = 100
  egress         = false
  protocol       = -1
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}
resource "aws_network_acl_rule" "egress_allow_rule" {
  network_acl_id = aws_network_acl.main_acl.id
  rule_number    = 100
  egress         = true
  protocol       = -1
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}
