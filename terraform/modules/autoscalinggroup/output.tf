data "aws_instances" "web" {
  filter {
    name   = "tag:Name"
    values = ["test-ec2"]
  }
}

output "instance_ids" {
  value = [for i in data.aws_instances.web.instances : i.id]
}

output "instance_public_ips" {
  value = [for i in data.aws_instances.web.instances : i.public_ip]
}
