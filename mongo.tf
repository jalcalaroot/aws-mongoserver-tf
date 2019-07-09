#################################################
# Definimos las claves de acceso a la API de AWS
#################################################

provider "aws" {
  access_key = "${var.access_key}" 
  secret_key = "${var.secret_key}"
  region     = "us-east-1" 
}

#------------------------------------------------------------
####################
# Security Group
####################

resource "aws_security_group" "sg" {
  name        = "${var.servername}-sg"
  description = "Allow all inbound traffic"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
   ingress {
    from_port = 27000
    to_port = 28000
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.servername}-sg"
  }
}
#-----------------------------------------------
###############
# keys
###############
resource "aws_key_pair" "mongo" {
  key_name = "mongo"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC7f56ewMZz4WLRzKLy8mnJ2ZS1gWhDiE3A4UinEqlogZQCuibNRSsF8C9oXg6IlxdeqBet5Zx4jf/qgTuEDVCF7QyyYxFtNKctSX901spJXhpusx4k9aMPmsTHGCj7DL1mHKwrvb7fSdJcsffo8R/3NWzP7bBcwLgZeTw/vSYvECNnco7yvPhIiHSvTfggj8s4tVEMb8vqkvfDJm6gRTpw3+KsA2yZGuiSFNQQcpbckVwbP5iSbalmJkRBPV5PWVx1wYLkSuPY4b6wAYyggfJ50rRO5Pvs7xhyJ7cXxTflE1OalZNpSLkAErYn4uuiW6az4BMHTB2aTVt98JEeoIwF jalcalaroot@jalcalaroot-VIT-P2412"
}

#-----------------------------------------------
resource "aws_instance" "mongo" {
  ami = "ami-059eeca93cf09eebd"
  key_name = "mongo"
  vpc_security_group_ids = ["${aws_security_group.sg.id}"]
  subnet_id = "${var.subnetid_1}"
  instance_type = "t2.small"
  user_data = "${file("deploy.sh")}"
  root_block_device {
  volume_type = "gp2"
  volume_size = 100
  }

  tags = {
    Name = "${var.servername}"
  }
 }
