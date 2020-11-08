variable "vpc_cidr" {
  type    = string
  default = ""
}
variable "instance_tenancy" {
  type    = string
  default = "default"
}
variable "ec2_subnets" {
  type = list(object(
    {
      az   = string,
      cidr = string
    }
  ))
  default = []
}
variable "pjprefix" {
  type    = string
  default = ""
}
