terraform {
  backend "s3" {
    bucket = "gitlab-backend-tfstate"
    key    = "sandbox/terraform.tfstate"
    region = "ap-southeast-1"
  }
}
