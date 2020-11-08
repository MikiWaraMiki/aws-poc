output "sg_id" {
  value = aws_security_group.ec2_security_group.id
}
output "ec2_arn" {
  value = aws_instance.main.arn
}
output "ec2_id" {
  value = aws_instance.main.id
}
output "ec2_ip" {
  value = aws_eip.ec2_eip.public_ip
}
