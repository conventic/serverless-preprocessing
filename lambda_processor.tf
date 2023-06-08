# Processor 
resource "aws_lambda_function" "preprocess" {
  function_name = "preprocess"
  role          = aws_iam_role.preprocessLambdaRole.arn
  package_type  = "Image"
  # Replace image_uri with your ECR image uri
  image_uri     = "710731193510.dkr.ecr.eu-central-1.amazonaws.com/preprocessor@sha256:f842c0f5dbfaad9afdd37a2752d981adf01edf14f27c5ae05f8169ccc0a97c1c"

  timeout     = 300
  memory_size = 10240
}

resource "aws_lambda_permission" "with_sns" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.preprocess.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.preprocessor.arn
}

resource "aws_sns_topic_subscription" "snsPreprocessor" {
  topic_arn = aws_sns_topic.preprocessor.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.preprocess.arn
  confirmation_timeout_in_minutes = 0
}

# Define the role
resource "aws_iam_role" "preprocessLambdaRole" {
  name = "preprocessLambdaRole"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}


# Policy related to S3 PutObject permission
resource "aws_iam_policy" "lambda_s3_put" {
  name        = "lambda_s3_put"
  description = "Allow Lambda to put objects to S3 bucket"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "VisualEditor0",
      "Effect": "Allow",
      "Action": "s3:PutObject",
      "Resource": "${aws_s3_bucket.preprocessed_serverless.arn}/*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_s3_put_attach" {
  role       = aws_iam_role.preprocessLambdaRole.name
  policy_arn = aws_iam_policy.lambda_s3_put.arn
}

#  Policy related to CloudWatch Logs
resource "aws_iam_policy" "lambda_logs" {
  name        = "lambda_logs"
  description = "Allow Lambda to create and write CloudWatch Logs"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "logs:CreateLogGroup",
      "Resource": "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": [
        "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/preprocess:*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs_attach" {
  role       = aws_iam_role.preprocessLambdaRole.name
  policy_arn = aws_iam_policy.lambda_logs.arn
}