output "vpc_id" {
  description = "vpc id"
  value       = module.network.vpc_id
}
output "subnet_id" {
  description = "subnet_id"
  value       = module.network.subnet_id
}
output "eip" {
  description = "ec2 attach ip"
  value       = module.ec2.ec2_ip
}
output "ec2_arn" {
  description = "ec2"
  value       = module.ec2.ec2_arn
}
output "s3_bucket_arn" {
  description = "kinesis s3 arn"
  value       = module.s3.arn
}
output "kinesis_arn" {
  description = "kinesis arn"
  value       = module.kinesis.arn
}
