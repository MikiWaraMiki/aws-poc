resource "aws_cloudwatch_log_subscription_filter" "kinesis_function_log_filter" {
  count           = length(var.log_group_names)
  name            = "kinesis-function-logfilter-${var.pjprefix}"
  log_group_name  = element(var.log_group_names, count.index)
  filter_pattern  = ""
  destination_arn = element(var.kinesis_arns, count.index)
  role_arn        = var.role_arn
  distribution    = "ByLogStream"
}
