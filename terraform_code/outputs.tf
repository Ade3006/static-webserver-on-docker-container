output "ecr_web_repo_url" {
  value = aws_ecr_repository.webapp.repository_url
}

output "ecr_mysql_repo_url" {
  value = aws_ecr_repository.mysql.repository_url
}

output "ec2_public_ip" {
  value = aws_instance.app_host.public_ip
}

