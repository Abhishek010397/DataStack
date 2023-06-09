data "archive_file" "lambda" {
  type        = "zip"
  source_file = var.lambda_source_file 
  output_path = "lambda_function.zip"
}

resource "aws_lambda_function" "batch_job_lambda" {
  filename         = "lambda_function.zip"
  function_name    = var.lambda_function_name
  role             = var.iam_role_lambda
  handler          = "lambda_function.lambda_handler"
  source_code_hash = data.archive_file.lambda.output_base64sha256
  runtime          = "python3.9"
  timeout          = 900

  vpc_config {
    subnet_ids         = [var.public_subnet_ids[0], var.public_subnet_ids[1], var.public_subnet_ids[2]]
    security_group_ids = [var.lambda_security_group_id]
  }

  environment {
    variables = {
      INSTANCE_ID = var.instance_id
    }
  }
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.batch_job_lambda.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = var.s3_bucket_arn
}