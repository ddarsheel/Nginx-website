

output "instance_id" {
  description = "Instance ID of current instance"
  value = aws_instance.web.id
}

output "public_ip" {
  description = "Public_ip address"
  value = aws_instance.web.public_ip
}
