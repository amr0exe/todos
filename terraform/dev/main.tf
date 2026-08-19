terraform {
  required_version = ">= 1.6"
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 6.0" }
  }
}

locals {
  name = "todo-app-${var.environment}"
  tags = {
    Project = "todoAPP"
    Env     = var.environment
    Managed = "terraform"

  }
}

provider "aws" {
  region = var.region
}

data "http" "my_ip" {
  url = "http://checkip.amazonaws.com"
}

module "vpc" {
  source = "../modules/vpc"
  name   = "tf-amr-${var.environment}"
}

module "ecr" {
  source = "../modules/ecr"
  name   = local.name
  tags   = local.tags
}

module "hostedzone" {
  source      = "../modules/hostedzone"
  environment = var.environment

  alb_dns_name = module.alb.alb_dns_name
  alb_zone_id  = module.alb.alb_zone_id
}

module "alb" {
  source                   = "../modules/alb"
  public_subnet_ids        = module.vpc.public_subnet_ids
  target_group_arn         = module.ec2.target_group_arn
  vpc_id                   = module.vpc.vpc_id
  cert_arn                 = module.hostedzone.acm_certificate_arn
  backend_target_group_arn = module.ec2.backend_target_group_arn
}

module "ec2" {
  source                = "../modules/ec2"
  environment           = var.environment
  instance_type         = var.instance_type
  key_name              = var.key_name
  my_ip                 = "${chomp(data.http.my_ip.response_body)}/32"
  public_subnet_ids     = module.vpc.public_subnet_ids
  alb_security_group_id = module.alb.security_group_id
  vpc_id                = module.vpc.vpc_id
  tags                  = local.tags
}
