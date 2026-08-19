variable "public_subnet_ids" {
  type = list(string)
}

variable "target_group_arn" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "cert_arn" {
  type = string
}

variable "backend_target_group_arn" {
  type = string
}
