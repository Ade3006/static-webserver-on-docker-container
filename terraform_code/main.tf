data "aws_vpc" "default" {
  default = true
}

data "aws_iam_instance_profile" "lab_profile" {
  name = "LabInstanceProfile"
}

# Use a default subnet (default VPC subnets typically have route to IGW => public)
data "aws_subnets" "default_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

locals {
  subnet_id = data.aws_subnets.default_subnets.ids[0]
}

resource "aws_ecr_repository" "webapp" {
  name = var.ecr_web_repo_name
}

resource "aws_ecr_repository" "mysql" {
  name = var.ecr_mysql_repo_name
}

resource "aws_security_group" "app_sg" {
  name        = "clo835-a1-sg"
  description = "CLO835 A1 SG"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_cidr]
  }

  ingress {
    description = "Web blue"
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Web pink"
    from_port   = 8082
    to_port     = 8082
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Web lime"
    from_port   = 8083
    to_port     = 8083
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "amzn2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "app_host" {
  ami                         = data.aws_ami.amzn2.id
  instance_type               = var.instance_type
  subnet_id                   = local.subnet_id
  vpc_security_group_ids      = [aws_security_group.app_sg.id]
  key_name                    = var.key_name
  associate_public_ip_address = true
  iam_instance_profile = data.aws_iam_instance_profile.lab_profile.name

  tags = {
    Name = "clo835-a1-ec2"
  }
}

