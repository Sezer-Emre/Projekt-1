# output "instance_public_ip" {
#   description = "Public IP address of the EC2 instance"
#   value       = aws_instance.mein_VM.public_ip
# }

# output "web_server_url" {
#   value = "http://${aws_instance.mein_VM.public_ip}"
# }

# output "ssh_command" {
#   value = "ssh -i ${var.user_name}.pem ubuntu@${aws_instance.mein_VM.public_ip}"
# }

output "web_server_url" {
  value = [
    for idx, i in aws_instance.mein_VM : idx == 0 ? "http://${i.public_ip}" : null
    if idx == 0
  ]
}

output "ssh_command_ubuntu" {
  value = [
    for idx, i in aws_instance.mein_VM : "ssh -i ${var.user_name}.pem ${var.server_name[idx]}@${i.public_ip}"  
    
  ]
}

output "centos_url" {
  value = [
    for idx, i in aws_instance.mein_VM : idx == 1 ? [
      "Prometheus ID si: http://${i.public_ip}:9090",  # İkinci EC2'nin public IP'sine 9090 portu ekleyin
      "Grafana ID si: http://${i.public_ip}:3000"   # İkinci EC2'nin public IP'sine 3000 portu ekleyin
    ] : null
    if idx == 1
  ]
}




