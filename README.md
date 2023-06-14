# Efficient Serverless Data Preprocessing

Based on [clemenspeters/ARIMA](https://github.com/clemenspeters/ARIMA/tree/main/aws_lambda_taxi_data/processor_external_data).

## Setup

Use

```shell
terraform apply
```

to setup the required infrastructure in your AWS account.

## Invoke publisher lambda function

```shell
aws lambda invoke --function-name publishLinkToSNS lambda_output_publisher.txt
```

## Download result files from s3

```shell
aws s3 sync s3://preprocessed-serverless ./results_preprocessed_s3
```

## Cleanup

Use

```shell
terraform destroy
```

to remove all created infrastructure from your AWS account.

## Commands used to import existing infrastructure to Terraform

```shell
terraform import aws_s3_bucket.preprocessed_serverless preprocessed-serverless
terraform import aws_sns_topic.preprocessor arn:aws:sns:eu-central-1:710731193510:preprocessor

terraform import aws_ecr_repository.preprocessor preprocessor
terraform import aws_ecr_repository_policy.lambdaPolicy preprocessor

terraform import aws_lambda_function.preprocess arn:aws:lambda:eu-central-1:710731193510:function:preprocess
terraform import aws_sns_topic_subscription.snsPreprocessor arn:aws:sns:eu-central-1:710731193510:preprocessor:79976f18-6a21-470b-8478-cc3976a90788

terraform import aws_lambda_function.publisher arn:aws:lambda:eu-central-1:710731193510:function:publishLinkToSNS
terraform import aws_iam_role.publish_to_sns publishToSNS
terraform import aws_iam_role.preprocessLambdaRole preprocessLambdaRole
```

## Manual update of lambda function via zip file

1. Package your code

    ```shell
    (cd ./lambda_functions/publishLinkToSNS && zip -r ../../publishLinkToSNS.zip lambda_function.py)
    ```

2. Upload the code package to an S3 bucket

    ```shell
    aws s3 cp publishLinkToSNS.zip s3://preprocessed-serverless/publishLinkToSNS.zip
    ```

3. Update the Lambda function with the new code

    ```shell
    aws lambda update-function-code --function-name publishLinkToSNS --s3-bucket preprocessed-serverless --s3-key publishLinkToSNS.zip
    ```

## Demo commands

### Local

```shell
cd local
. ./download.sh 
python3 invoke_processor.py
```

#### Clean up local

```shell
rm -rf *.parquet
```

### AWS

```shell
terraform plan
terraform apply
date && aws lambda invoke --function-name publishLinkToSNS lambda_output_publisher.txt
aws s3 sync s3://preprocessed-serverless ./results_preprocessed_s3
terraform destroy
```

- [Lambda](https://eu-central-1.console.aws.amazon.com/lambda/home?region=eu-central-1#/functions?sb=lastModified&so=DESCENDING)
- [SNS](https://eu-central-1.console.aws.amazon.com/sns/v3/home?region=eu-central-1#/topics)
- [S3](https://s3.console.aws.amazon.com/s3/home?region=eu-central-1#)

#### Clean up AWS

```shell
terraform destroy
rm -rf results_preprocessed_s3
```
