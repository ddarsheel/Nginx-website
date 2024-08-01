resource "aws_ecr_repository" "nginx" {
  name = var.repo_name
}

output "repository_url" {
  value = aws_ecr_repository.nginx.repository_url
}