variable "allow_ingress_ips" {
  type    = list(string)
  default = []
}
variable "allow_ingress_ports" {
  type    = list(number)
  default = []
}
variable "vpc_id" {
  type    = string
  default = ""
}
variable "subnet_id" {
  type    = string
  default = ""
}
variable "instance_type" {
  type    = string
  default = ""
}
variable "key_file" {
  type    = any
  default = ""
}
variable "pjprefix" {
  type    = string
  default = ""
}
variable "role_name" {
  type    = string
  default = ""
}
