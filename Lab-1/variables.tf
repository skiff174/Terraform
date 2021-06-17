variable "region" {
  type    = string
  default = "us-east-1"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "vpc_cidr_block" {
  type    = string
  default = "10.99.0.0/16"
}

variable "db_cidr_block_1" {
  type    = string
  default = "10.99.21.0/24"
}

variable "db_cidr_block_2" {
  type    = string
  default = "10.99.22.0/24"
}

variable "public_cidr_block_1" {
  type    = string
  default = "10.99.1.0/24"
}

variable "public_cidr_block_2" {
  type    = string
  default = "10.99.2.0/24"
}

variable "app_cidr_block_1" {
  type    = string
  default = "10.99.11.0/24"
}

variable "app_cidr_block_2" {
  type    = string
  default = "10.99.12.0/24"
}

variable "az_1" {
  type    = string
  default = "us-east-1a"
}

variable "az_2" {
  type    = string
  default = "us-east-1b"
}
