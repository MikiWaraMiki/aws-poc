variable "log_group_names" {
  type    = list(string)
  default = []
}
variable "s3_arn" {
  type    = string
  default = ""
}
variable "role_arn" {
  type    = string
  default = ""
}
variable "buffer_size" {
  type    = number
  default = 5
}
variable "buffer_interval" {
  type    = number
  default = 60
}
variable "pjprefix" {
  type    = string
  default = ""
}
