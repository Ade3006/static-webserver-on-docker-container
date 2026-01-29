variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "key_name" {
  type        = string
  description = "Existing EC2 key pair name"
}

variable "ssh_cidr" {
  type        = string
  description = "Your public IP /32 for SSH"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "ecr_web_repo_name" {
  type    = string
  default = "webapp"
}

variable "ecr_mysql_repo_name" {
  type    = string
  default = "mysql"
}

