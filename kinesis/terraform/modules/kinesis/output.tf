output "arn" {
  value = aws_kinesis_firehose_delivery_stream.firehose.*.arn
}
