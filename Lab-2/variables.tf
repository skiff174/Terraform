variable "region" {
  type    = string
  default = "eu-north-1"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "vpc_cidr_block" {
  type    = string
  default = "192.168.0.0/16"
}

variable "webserver_cidr_block_1" {
  type    = string
  default = "192.168.11.0/24"
}

variable "webserver_cidr_block_2" {
  type    = string
  default = "192.168.12.0/24"
}

variable "bastion_host_cidr_block_1" {
  type    = string
  default = "192.168.1.0/24"
}

variable "bastion_host_cidr_block_2" {
  type    = string
  default = "192.168.2.0/24"
}

variable "az_1" {
  type    = string
  default = "eu-north-1a"
}

variable "az_2" {
  type    = string
  default = "eu-north-1b"
}
