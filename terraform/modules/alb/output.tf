output "alb_arn" {
  description = "The ARN of the ALB"
  value       = aws_lb.webapplication.arn
}

output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = aws_lb.webapplication.dns_name
}

output "target_group_arn" {
  description = "The ARN of the target group"
  value       = aws_lb_target_group.webapplication.arn
}

output "alb_zone_id" {
  description = "The alb zone id"
  value = aws_lb.webapplication.zone_id
}
