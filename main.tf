terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.25.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# resource "aws_default_vpc" "default" {
#   tags = {
#     Name = "Default VPC"
#   }
# }

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
  instance_type = "t2.micro"
  key_name = "Firstkey"
  vpc_security_group_ids = [aws_security_group.Proje_1_SG.id] #Degistir dene
  subnet_id   = aws_subnet.team1_publicsubnet.id
  

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

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.mein_VM.public_ip
}
