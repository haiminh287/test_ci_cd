provider "aws" {
  region = var.region
}

resource "aws_key_pair" "k8s_key" {
  key_name   = "k8s-key"
  public_key = file("key.pem.pub")
}

resource "aws_security_group" "k8s_sg" {
  name        = "k8s-sg"
  description = "Allow K8s traffic"

  ingress = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 6443
      to_port     = 6553
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 30000
      to_port     = 32767
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  egress = [{
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }]
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical (Ubuntu)
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

resource "aws_instance" "master" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.medium"
  key_name      = aws_key_pair.k8s_key.key_name
  security_groups = [aws_security_group.k8s_sg.name]
  tags = {
    Name = "k8s-master"
  }
}

resource "aws_instance" "worker" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.medium"
  key_name      = aws_key_pair.k8s_key.key_name
  security_groups = [aws_security_group.k8s_sg.name]
  tags = {
    Name = "k8s-worker"
  }
}
