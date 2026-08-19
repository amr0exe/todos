variable "instance_type" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "environment" {
  type = string
}

variable "key_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "my_ip" {
  type = string
}

variable "alb_security_group_id" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}
