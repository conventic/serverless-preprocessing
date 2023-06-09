# Define the S3 bucket
resource "aws_s3_bucket" "preprocessed_serverless" {
  bucket        = "preprocessed-serverless"
  force_destroy = true
}

# resource "null_resource" "zip_file" {
#   provisioner "local-exec" {
#     command = "(cd ./lambda_functions/publishLinkToSNS && zip -r ../../publishLinkToSNS.zip lambda_function.py)"
#   }

#   triggers = {
#     always_run = "${timestamp()}"
#   }
# }

# resource "aws_s3_bucket" "publisher_code" {
#   bucket        = "serverless-publisher-code"
#   force_destroy = true
# }

# resource "aws_s3_object" "object" {
#   bucket     = aws_s3_bucket.publisher_code.bucket
#   key        = "publishLinkToSNS.zip"
#   source     = "publishLinkToSNS.zip" // replace with the path to your local file
#   depends_on = [null_resource.zip_file]
# }
