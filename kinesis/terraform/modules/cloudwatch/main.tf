resource "aws_cloudwatch_log_group" "main" {
  count             = length(var.log_group_names)
  name              = element(var.log_group_names, count.index)
  retention_in_days = var.retention_in_days
}
resource "aws_cloudwatch_log_stream" "main" {
  count          = length(var.log_stream_params)
  name           = lookup(element(var.log_stream_params, count.index), "name", null)
  log_group_name = lookup(element(var.log_stream_params, count.index), "log_group_name", null)
}
