resource "aws_lambda_function" "preprocess" {
  function_name = "arn:aws:lambda:eu-central-1:710731193510:function:preprocess"
  role          = "arn:aws:iam::710731193510:role/service-role/preprocessLambdaRole"
  package_type  = "Image"
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