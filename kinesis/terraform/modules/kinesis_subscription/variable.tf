variable "log_group_names" {
  type    = list(string)
  default = []
}
variable "kinesis_arns" {
  type    = list(string)
  default = []
}
variable "role_arn" {
  type    = string
  default = ""
}
variable "pjprefix" {
  type    = string
  default = ""
}
