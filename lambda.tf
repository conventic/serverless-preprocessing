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
