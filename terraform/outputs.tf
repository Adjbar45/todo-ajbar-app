output "ec2_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.web.public_ip
}

output "rds_endpoint" {
  description = "Connection endpoint for the RDS database"
  value       = aws_db_instance.todo_db.endpoint
}

output "app_url" {
  description = "URL to access the app once deployed"
  value       = "http://${aws_instance.web.public_ip}:5000"
}
