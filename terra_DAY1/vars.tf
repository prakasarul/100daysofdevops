variable "aws_region" {
  default = "ap-south-1"
}

variable "profile" {
  default = "divdevops"
}

variable "key_name" {
  default = "terra-key"
}

variable "public_key_path" {
  default = "/root/.ssh/id_rsa.pub"
}

variable "instance_type" {
  default = "t2.micro"
}



variable "ami_id" {
  default = "ami-0ec8900bf6d32e0a8"
}

variable "alarms_email" {
  default = "prakasarul222@gmail.com"
}
