
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical #Degistirip dene
}

resource "aws_instance" "mein_VM" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name = var.user_name
  vpc_security_group_ids = [aws_security_group.Proje_1_SG.id] #Degistir dene
  subnet_id   = aws_subnet.team1_publicsubnet.id
  user_data = file("./script.sh")
  

  tags = {
    Name = "Proje_team_1"
  }
}

resource "aws_security_group" "Proje_1_SG" {
  name        = "Proje_1_SG"
  description = "SSH,HTTP,HTTPS allow"
  vpc_id      = aws_vpc.team1_vpc.id

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

}

# output "instance_public_ip" {
#   description = "Public IP address of the EC2 instance"
#   value       = aws_instance.mein_VM.public_ip
# }

output "web_server_url" {
  value = "http://${aws_instance.mein_VM.public_ip}"
}

output "ssh_command" {
  value = "ssh -i ${var.user_name}.pem ubuntu@${aws_instance.mein_VM.public_ip}"
}

#TODOS: userdata.sh and key-pair resource