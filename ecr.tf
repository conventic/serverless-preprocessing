# resource "aws_ecr_repository" "preprocessor" {
#   name                 = "preprocessor"
#   image_tag_mutability = "MUTABLE"

#   lifecycle {
#     prevent_destroy = true
#   }

# }

# resource "aws_ecr_repository_policy" "lambdaPolicy" {
#   repository = aws_ecr_repository.preprocessor.name
#   policy = <<EOF
# {
#   "Version": "2008-10-17",
#   "Statement": [
#     {
#       "Sid": "LambdaECRImageRetrievalPolicy",
#       "Effect": "Allow",
#       "Principal": {
#         "Service": "lambda.amazonaws.com"
#       },
#       "Action": [
#         "ecr:BatchGetImage",
#         "ecr:DeleteRepositoryPolicy",
#         "ecr:GetDownloadUrlForLayer",
#         "ecr:GetRepositoryPolicy",
#         "ecr:SetRepositoryPolicy"
#       ],
#       "Condition": {
#         "StringLike": {
#           "aws:sourceArn": "arn:aws:lambda:eu-central-1:710731193510:function:*"
#         }
#       }
#     }
#   ]
# }
# EOF
# }