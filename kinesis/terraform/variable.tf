variable "region" {}
variable "profile" {}
variable "key_file_path" {}

variable "pjprefix" {
  default = "kinesis-sample"
}
variable "vpc_cidr" {
  default = "172.17.0.0/16"
}
variable "ec2_subnets" {
  default = [
    {
      az : "ap-northeast-1a",
      cidr : "172.17.0.0/24"
    }
  ]
}
variable "allow_ingress_ips" {
  default = [
    "106.154.138.235/32"
  ]
}
variable "allow_ingress_ports" {
  default = [22]
}
variable "instance_type" {
  default = "t3.small"
}
variable "log_group_names" {
  default = ["ec2"]
}
variable "log_stream_params" {
  default = [
    {
      name           = "nginx",
      log_group_name = "ec2"
    },
    {
      name           = "test",
      log_group_name = "ec2"
    },
    {
      name           = "cloudwatch-agent",
      log_group_name = "ec2"
    }
  ]
}
