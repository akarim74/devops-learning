output "wordpress_instance_id" {
  description = "ID of the WordPress EC2 instance."
  value       = aws_instance.wordpress.id
}

output "wordpress_public_ip" {
  description = "Public IPv4 address of the WordPress EC2 instance."
  value       = aws_instance.wordpress.public_ip
}

output "wordpress_url" {
  description = "HTTP URL of the WordPress website."
  value       = "http://${aws_instance.wordpress.public_ip}"
}
