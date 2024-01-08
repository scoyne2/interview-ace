variable "connections-table-name" {}
variable "connections-history-table-name" {}

data "aws_iam_policy_document" "interview-ace-lambda-assume-role-policy"{
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "interview-ace-lambda-role" {
  name = "interview-ace-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.interview-ace-lambda-assume-role-policy.json
}

resource "aws_iam_role_policy_attachment" "interview-ace-lambda-policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.interview-ace-lambda-role.name
}

data "archive_file" "interview-ace-websocket-lambda-package" {
  type = "zip"
  source_file = "${path.module}/websocket-lambda/lambda.py"
  output_path = "websocket-lambda.zip"
}

resource "aws_lambda_function" "interview-ace-websocket-lambda" {
        function_name = "InterviewAceWebsocketLambda"
        filename      = "websocket-lambda.zip"
        source_code_hash = data.archive_file.interview-ace-websocket-lambda-package.output_base64sha256
        role          = aws_iam_role.interview-ace-lambda-role.arn
        runtime       = "python3.12"
        handler       = "lambda_function.lambda_handler"
        timeout       = 10
        architectures = ["arm64"]

         environment {
            variables = {
                DYNAMODB_TABLE_NAME = var.connections-table-name,
                DYNAMODB_HISTORY_TABLE_NAME = var.connections-history-table-name
            }
        }
}

output "websocket-lambda-arn" {
  value = resource.aws_lambda_function.interview-ace-websocket-lambda.arn
}