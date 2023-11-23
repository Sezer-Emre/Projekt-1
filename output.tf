output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.mein_VM.public_ip
}

output "web_server_url" {
  value = "http://${aws_instance.mein_VM.public_ip}"
}

output "ssh_command" {
  value = "ssh -i ${var.user_name}.pem ubuntu@${aws_instance.mein_VM.public_ip}"
}