# Publisher

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "./lambda/publishLinkToSNS/lambda_function.py"
  output_path = "publishLinkToSNS.zip"
}

resource "aws_lambda_function" "publisher" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "publishLinkToSNS.zip"
  function_name = "publishLinkToSNS"
  role          = aws_iam_role.publish_to_sns.arn
  handler       = "lambda_function.lambda_handler"
  timeout = "60"

  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "python3.10"
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "publish_to_sns" {
  name               = "publishToSNS"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

data "aws_iam_policy_document" "sns_publish" {
  statement {
    effect = "Allow"

    actions = ["sns:Publish"]
    
    resources = [aws_sns_topic.preprocessor.arn]
  }
}

resource "aws_iam_role_policy" "sns_publish_policy" {
  name   = "sns_publish_policy"
  role   = aws_iam_role.publish_to_sns.id
  policy = data.aws_iam_policy_document.sns_publish.json
}