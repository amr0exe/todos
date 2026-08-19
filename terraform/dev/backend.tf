terraform {
  backend "s3" {
    bucket       = "unified-backend-amr"
    key          = "dev/terraform.tfstate"
    region       = "ap-south-1"
    encrypt      = true
    use_lockfile = true
  }
}
