
data "aws_ami" "centos" {          ## Bu sekilde de amazon kernel 5.10 oluyor.
  most_recent = true    
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.*-x86_64-gp2"]        # amazon/amzn2-ami-kernel-5.10-hvm-2.0.20231116.0-x86_64-gp2
  }
}


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
  count         = 2
  ami           = count.index == 0 ? data.aws_ami.ubuntu.id  : data.aws_ami.centos.id  # data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name = var.user_name
  vpc_security_group_ids = [aws_security_group.Proje_1_SG.id] #Degistir dene
  subnet_id   = aws_subnet.team1_publicsubnet.id
  iam_instance_profile = count.index == 1 ? aws_iam_instance_profile.test_profile.name : null  ## Ikinci Ec2 icin
  #user_data     = var.user_data_list[count.index] #user_data = file("./script.sh")
  #user_data     = count.index == 0 ? data.ubuntu.user_data_1.rendered : data.grafana.user_data_2.rendered
  user_data = count.index == 0 ? file("./user_data_file/script.sh") : file("./user_data_file/grafana_script.sh")


  tags = {
    Name = var.instance_name[count.index]
  }
}





