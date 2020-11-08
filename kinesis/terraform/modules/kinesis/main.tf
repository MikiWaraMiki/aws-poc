resource "aws_kinesis_firehose_delivery_stream" "firehose" {
  # Kinesisはロググループごとに作成する必要がある
  count       = length(var.log_group_names)
  destination = "s3"
  name        = "kinesis-firehose-for-${element(var.log_group_names, count.index)}"

  s3_configuration {
    role_arn        = var.role_arn
    bucket_arn      = var.s3_arn
    buffer_size     = var.buffer_size
    buffer_interval = var.buffer_interval
    prefix          = element(var.log_group_names, count.index)

    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = element(var.log_group_names, count.index)
      log_stream_name = "nginx"
    }
  }

  tags = {
    Name     = "kinesis-firehose-for-${element(var.log_group_names, count.index)}"
    PJPrefix = var.pjprefix
  }
}
