resource "aws_iam_role" "lambda_execution_role" {
  name                = "iam_role_lambda_function"
  assume_role_policy  = <<EOF
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
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AWSLambdaRole"]
}

data "archive_file" "default" {
  type        = "zip"
  source_dir  = "${path.module}/app"
  output_path = "${path.module}/app.zip"
}

resource "aws_lambda_function" "terraform_lambda_demo" {
  filename      = "${path.module}/app.zip"
  function_name = "terraform-lambda-demo"
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = "index.handler"
  runtime       = "nodejs14.x"
  architectures = ["arm64"]
}

resource "aws_lambda_function_url" "public_endpoint" {
  function_name      = aws_lambda_function.terraform_lambda_demo.function_name
  authorization_type = "NONE"
}
