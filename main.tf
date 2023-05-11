terraform {
  backend "s3" {
    bucket = "clemens-terraform-state"
    key    = "serverless-preprocessing-2023"
    region = "eu-central-1"
    profile = "conventic" # You only need this if you want to use a specific aws-cli profile
  }
}