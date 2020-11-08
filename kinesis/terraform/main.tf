######################################################
# Kinesis Sample
######################################################
terraform {
  required_version = ">= 0.12.0"
  backend s3 {
  }
}
provider "aws" {
  region  = var.region
  profile = var.profile
}
########################
# Network
########################
module "network" {
  source = "./modules/network/"

  vpc_cidr    = var.vpc_cidr
  ec2_subnets = var.ec2_subnets
  pjprefix    = var.pjprefix
}

########################
# EC2 IAM
########################
data "aws_iam_policy" "cloudwatch_agent_policy" {
  arn = "arn:aws:iam::aws:policy/CloudWatchAgentAdminPolicy"
}
data "aws_iam_policy_document" "ec2" {
  source_json = data.aws_iam_policy.cloudwatch_agent_policy.policy
  statement {
    effect    = "Allow"
    actions   = ["s3:*"]
    resources = ["*"]
  }
}
module "ec2_iam" {
  source     = "./modules/iam/"
  name       = "ec2-role-${var.pjprefix}"
  identifier = "ec2.amazonaws.com"
  policy     = data.aws_iam_policy_document.ec2.json
}
########################
# EC2
########################
module "ec2" {
  source = "./modules/ec2/"

  allow_ingress_ips   = var.allow_ingress_ips
  allow_ingress_ports = var.allow_ingress_ports
  vpc_id              = module.network.vpc_id
  subnet_id           = module.network.subnet_id[0]
  instance_type       = var.instance_type
  key_file            = file(var.key_file_path)
  role_name           = module.ec2_iam.name
  pjprefix            = var.pjprefix
}

#########################
# S3 for Kinesis
##########################
module "s3" {
  source      = "./modules/s3/"
  bucket_name = "tokoroga-dokkoi-kinesis-${var.pjprefix}"
}

##########################
# Kinesis IAM
##########################
module "kinesis_iam" {
  source     = "./modules/iam/"
  name       = "firehose-role-${var.pjprefix}"
  identifier = "firehose.amazonaws.com"
  policy     = jsonencode(yamldecode(file("./yaml/iam/kinesis.yml")))
}
module "kinesis" {
  source          = "./modules/kinesis/"
  log_group_names = var.log_group_names
  s3_arn          = module.s3.arn
  role_arn        = module.kinesis_iam.arn
  pjprefix        = var.pjprefix
}

##########################
# CloudWatch log group
###########################
module "cloudwatch_log_group" {
  source            = "./modules/cloudwatch/"
  log_group_names   = var.log_group_names
  log_stream_params = var.log_stream_params
  retention_in_days = 30
}

##########################
# CloudWatch Iam for firehose
###########################
data "aws_iam_policy_document" "cloudwatch_logs" {
  statement {
    effect    = "Allow"
    actions   = ["firehose:*"]
    resources = ["arn:aws:firehose:ap-northeast-1:*:*"]
  }

  statement {
    effect    = "Allow"
    actions   = ["iam:PassRole"]
    resources = ["arn:aws:iam::*:role/cloudwatch-logs"]
  }
}
module "cloudwatch_iam" {
  source     = "./modules/iam/"
  name       = "cloudwatch-role-${var.pjprefix}"
  identifier = "logs.ap-northeast-1.amazonaws.com"
  policy     = data.aws_iam_policy_document.cloudwatch_logs.json
}

###########################
# Subscriber
###########################
module "kinesis_subscriber" {
  source          = "./modules/kinesis_subscription/"
  log_group_names = var.log_group_names
  kinesis_arns    = module.kinesis.arn
  role_arn        = module.cloudwatch_iam.arn
  pjprefix        = var.pjprefix

  depends_on = [
    module.cloudwatch_log_group
  ]
}
