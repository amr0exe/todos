variable "region" {
  type    = string
  default = "us-east-1"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "key_name" {
  type    = string
  default = "ue-test"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}
