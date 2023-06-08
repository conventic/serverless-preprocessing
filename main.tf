terraform {
  backend "s3" {
    bucket = "clemens-terraform-state"
    key    = "serverless-preprocessing-2023"
    region = "eu-central-1"
  }
}

# Define AWS provider
provider "aws" {
  region = "eu-central-1"

  default_tags {
    tags = {
      project = "serverless-preprocessing-2023"
    }
  }
}
