# Define AWS provider
provider "aws" {
  region = "eu-central-1"
}

# Define the S3 bucket
resource "aws_s3_bucket" "preprocessed_serverless" {
  bucket = "preprocessed-serverless"

  tags = {
    Name        = "project"
    Environment = "serverless-preprocessing-2023"
  }
}
