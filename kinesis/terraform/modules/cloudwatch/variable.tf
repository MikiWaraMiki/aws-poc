variable "log_group_names" {
  type    = list(string)
  default = []
}
variable "log_stream_params" {
  type = list(object(
    {
      name           = string,
      log_group_name = string
    }
  ))
  default = []
}
variable "retention_in_days" {
  type    = number
  default = 180
}
